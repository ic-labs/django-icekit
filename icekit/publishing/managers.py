from django.db import models
from django.db.models.query import QuerySet
from django.db.models.query_utils import Q
from django.utils.timezone import now

from polymorphic.manager import PolymorphicManager
from polymorphic.query import PolymorphicQuerySet

from fluent_pages.models.managers import UrlNodeQuerySet, UrlNodeManager
from fluent_pages.models.db import UrlNode

from .middleware import is_draft_request_context, \
    is_publishing_middleware_active
from .utils import PublishingException


UNSET = object()  # Constant object to mark unset kwargs


class DraftItemBoobyTrap(object):
    """
    Wrapper for draft publishable items intended to prevent any misuse of
    draft items by accessing their data while in a published-only request
    context.

    This class will pass through a shortlist of safe attrs/methods to the
    wrapped payload object, just enough so the publishing status can be checked
    or the actual published copy can be obtained by downstream code.

    For any other attr/method access attempts, which most likely are the result
    of treating a draft item as if it were published, this class will raise an
    exception explaining why the access was illegal and recommend steps for
    devs to fix the problem.

    The list of permitted attr/method names can be extended from the values
    in ``DEFAULT_PERMITTED_ATTRS`` by specifying the list attribute
    ``PUBLISHING_DRAFT_PERMITTED_ATTRS`` on the draft object or class.
    """
    # Attribute or method names that are safe to access, for checking on draft
    # status or exchanging a draft payload for the published copy.
    DEFAULT_PERMITTED_ATTRS = [
        'get_draft',
        'get_draft_payload',
        'get_published',
        'get_visible',
        'get_published_or_draft',
        # NOTE: `get_draft` is not included here to discourage getting a draft
        'publishing_linked',
        'publishing_linked_id',
        'publishing_is_draft',
        'is_published',
        'has_been_published',
        'is_draft',
        'is_visible',
        # Fields that need to be accessible for Fluent Pages processing
        'pk',
        'id',
        'language_code',
        'get_current_language',
        'set_current_language',
        # Fields that need to be accessible by any_urlfield
        # TODO: consider either patching fetching published model into
        # ICEkitURLField or ensure that draft and published objects always
        # have the same URL (that of the published object).
        'get_absolute_url',
    ]

    def __init__(self, payload):
        if not payload.publishing_is_draft:
            raise ValueError(
                "'{0}' is not a DRAFT, and only DRAFT items may be wrapped"
                " by {1}".format(payload, self.__class__))
        self._draft_payload = payload
        # Prepare list of permitted attr/method names
        permitted_attr_list = self.DEFAULT_PERMITTED_ATTRS
        permitted_attr_list += getattr(self._draft_payload,
                                       'PUBLISHING_PERMITTED_ATTRS', [])
        self.permitted_attrs = dict([(i, None) for i in permitted_attr_list])

    def __getattr__(self, name):
        if name in self.permitted_attrs:
            return getattr(self._draft_payload, name)
        else:
            raise PublishingException(
                "Illegal attempt to access '{0}' on the DRAFT publishable item"
                " '{1}' in a public context, where only {2} can be accessed."
                " Get the published copy for this item by calling `published`"
                " / `visible` on the source queryset, or  `get_published` /"
                " `get_visible` on a single-item relationship"
                .format(name, self._draft_payload, self.permitted_attrs.keys())
            )

    def get_draft_payload(self):
        """
        Get the wrapped payload directly, but only do this if you are *sure*
        you know what you are doing and cannot bypass the publishing checks
        another way!
        """
        return self._draft_payload


def _exchange_for_published(qs):
    """
    Exchange the results in a queryset of publishable items for the
    corresponding published copies. This means the result QS has:
        - already published items in original QS
        - the published copies for drafts with published versions
        - unpublished draft items in the original QS are removed.

    Unfortunately we cannot just perform a normal queryset filter operation
    in the DB because FK/M2M relationships assigned in the site admin are
    *always* to draft objects. Instead we exchange draft items for
    published copies.
    """
    # TODO: Can this be lazily executed when a queryset is evaluated?
    # Currently any `published()` queryset will obtain its list available
    # published PKs when this function is called, which might not be
    # immediately before the queryset is evaluated. It might be possible
    # to pass a subquery instead of collecting PKs into a list to pass?
    published_version_pks = []
    draft_version_pks = []
    is_exchange_required = False
    # Use direct DB query if possible (be sure to prioritise the ordering of
    # the draft items over the published items by checking the draft items
    # first, since the draft item ordering may be explicitly set via admin)...
    from .models import PublishingModel
    if issubclass(qs.model, PublishingModel):
        for pk, publishing_is_draft, publishing_linked_id in qs.values_list(
                'pk', 'publishing_is_draft', 'publishing_linked_id'):
            # If item is draft and if it has a linked published copy, exchange
            # the draft to get the published copy instead...
            if publishing_is_draft:
                draft_version_pks.append(pk)
                if publishing_linked_id:
                    published_version_pks.append(publishing_linked_id)
                    is_exchange_required = True
            # ...otherwise if item is already the published copy, use it.
            elif not publishing_is_draft:
                published_version_pks.append(pk)
    # ...otherwise we are forced to retrieve the real instances to check fields
    # and we may be dealing with a UrlNode model without our own publishing
    # fields so be defensive in our field lookups.
    else:
        for item in qs:
            # If item is draft and if it has a linked published copy, exchange
            # the draft to get the published copy instead...
            if getattr(item, 'publishing_is_draft', None):
                draft_version_pks.append(item.pk)
                if getattr(item, 'publishing_linked_id', None):
                    published_version_pks.append(item.publishing_linked_id)
                    is_exchange_required = True
            # ...otherwise if item is already the published copy, use it.
            elif getattr(item, 'is_published', None):
                published_version_pks.append(item.pk)
    # Only perform exchange query and re-ordering if necessary
    if not is_exchange_required:
        # If no exchange is required, we must make sure any draft items we
        # found are excluded from the queryset since we won't be filtering by
        # published-item PKs
        return qs.exclude(pk__in=draft_version_pks)
    else:
        # TODO: Salvage more attributes from the original queryset, such as
        # `annotate()`, `distinct()`, `select_related()`, `values()`, etc.
        qs = qs.model.objects.filter(pk__in=published_version_pks)
        # Restore ordering from original queryset.
        qs = _order_by_pks(qs, published_version_pks)
        return qs


def _order_by_pks(qs, pks):
    """
    Adjust the given queryset to order items according to the explicit ordering
    of PKs provided.

    This is a PostgreSQL-specific DB hack, based on:
    blog.mathieu-leplatre.info/django-create-a-queryset-from-a-list-preserving-order.html
    """
    pk_colname = '%s.%s' % (
        qs.model._meta.db_table, qs.model._meta.pk.column)
    clauses = ' '.join(
        ['WHEN %s=%s THEN %s' % (pk_colname, pk, i)
            for i, pk in enumerate(pks)]
    )
    ordering = 'CASE %s END' % clauses
    return qs.extra(
        select={'pk_ordering': ordering}, order_by=('pk_ordering',))


def _queryset_visible(qs):
    """
    Return the visible version of publishable items, which means:
    - for privileged users: all draft items, whether published or not
    - for everyone else: the published copy of items.
    """
    if is_draft_request_context():
        # All draft objects, and only draft objects.
        return qs.draft()
    else:
        return qs.published()


def _queryset_iterator(qs):
    """
    Override default iterator to wrap returned items in a publishing
    sanity-checker "booby trap" to lazily raise an exception if DRAFT
    items are mistakenly returned and mis-used in a public context
    where only PUBLISHED items should be used.

    This booby trap is added when all of:

    - the publishing middleware is active, and therefore able to report
    accurately whether the request is in a drafts-permitted context
    - the publishing middleware tells us we are not in
    a drafts-permitted context, which means only published items
    should be used.
    """
    # Avoid double-processing draft items in our custom iterator when we
    # are in a `PublishingQuerySet` that is also a subclass of the
    # monkey-patched `UrlNodeQuerySet`
    if issubclass(type(qs), UrlNodeQuerySet):
        super_without_boobytrap_iterator = super(UrlNodeQuerySet, qs)
    else:
        super_without_boobytrap_iterator = super(PublishingQuerySet, qs)

    if is_publishing_middleware_active() \
            and not is_draft_request_context():
        for item in super_without_boobytrap_iterator.iterator():
            if getattr(item, 'publishing_is_draft', False):
                yield DraftItemBoobyTrap(item)
            else:
                yield item
    else:
        for item in super_without_boobytrap_iterator.iterator():
            yield item


class PublishingQuerySet(QuerySet):
    """
    Base publishing queryset features, without UrlNode customisations.
    """
    # Do not perform draft-to-published item exchange by default to avoid
    # performance penalties. This class attribute exists to be enabled only
    # where it is really necessary: on relationship querysets.
    exchange_on_published = False

    def visible(self):
        return _queryset_visible(self)

    def draft(self):
        """
        Filter items to only those that are actually draft, though each draft
        item may or may not have an associated published version.

        In most cases this filter will do no real work, since we almost always
        deal with only draft versions when interacting with publishable items.
        """
        queryset = self.all()
        return queryset.filter(publishing_is_draft=True)

    def published(self, for_user=UNSET, force_exchange=False):
        """
        Filter items to include only those that are actually published.

        By default, this method will apply a filter to find published items
        where `publishing_is_draft==False`.

        If it is necessary to exchange draft items for published copies, such
        as for relationships defined in the admin that only capture draft
        targets, the exchange mechanism is triggered either by forcing it
        with `force_exchange==True` or by enabling exchange by default at
        the class level with `exchange_on_published==True`. In either case,
        this method will return only the published object copies of published
        items.

        It should be noted that Fluent's notion of "published" items is
        different from ours and is user-sensitive such that privileged users
        actually see draft items as published. To make Fluent's notion of
        published items align with ours this method also acts as a shim for our
        ``visible`` filter and will return visible items when invoked by
        Fluent's view resolution process that provides the ``for_user`` kwarg.
        """
        # Re-interpret call to `published` from within Fluent to our
        # `visible` implementation, if the `for_user` kwarg is provided by the
        # calling code with a value other than `UNSET`. We use the `UNSET` flag
        # so we can distinguish calls that actually include `for_user`.
        # NOTE: This could well come straight back to us if `visible` calls
        # `published`, but the 'for_user' value will have been stripped.
        # NOTE 2: The ``for_user`` keyword argument is a no-op for us, we
        # support it solely for compatibility with Fluent code that expects it.
        if for_user is not UNSET:
            return self.visible()

        queryset = self.all()
        if force_exchange or self.exchange_on_published:
            # Exclude any draft items without a published copy. We keep all
            # published copy items, and draft items with a published copy, so
            # result may contain both draft and published items.
            queryset = queryset.exclude(
                publishing_is_draft=True, publishing_linked=None)
            # Return only published items, exchanging draft items for their
            # published copies where necessary.
            return queryset.exchange_for_published()
        else:
            # No draft-to-published exchange requested, use simple constraint
            return queryset.filter(publishing_is_draft=False)

    def exchange_for_published(self):
        return _exchange_for_published(self)

    def iterator(self):
        return _queryset_iterator(self)

    def only(self, *args, **kwargs):
        """
        Override default implementation to ensure that we *always* include the
        `publishing_is_draft` field when `only` is invoked, to avoid eternal
        recursion errors if `only` is called then we check for this item
        attribute in our custom `iterator`.

        Discovered the need for this by tracking down an eternal recursion
        error in the `only` query performed in
        fluent_pages.urlresolvers._get_pages_of_type
        """
        field_names = args
        if 'publishing_is_draft' not in field_names:
            field_names += ('publishing_is_draft',)
        return super(PublishingQuerySet, self) \
            .only(*field_names, **kwargs)


class PublishingPolymorphicQuerySet(PublishingQuerySet, PolymorphicQuerySet):
    pass


class PublishingUrlNodeQuerySet(PublishingQuerySet, UrlNodeQuerySet):
    """
    Publishing queryset with customisations for UrlNode support.
    """

    def published(self, for_user=UNSET, force_exchange=False):
        """
        Apply additional filtering of published items over that done in
        `PublishingQuerySet.published` to filter based on additional publising
        date fields used by Fluent.
        """
        if for_user is not UNSET:
            return self.visible()

        queryset = super(PublishingUrlNodeQuerySet, self).published(
            for_user=for_user, force_exchange=force_exchange)

        # Exclude by publication date on the published version of items, *not*
        # the draft vesion, or we could get the wrong result.
        # Exclude fields of published copy of draft items, not draft itself...
        queryset = queryset.exclude(
            Q(publishing_is_draft=True) & Q(
                Q(publishing_linked__publication_date__gt=now())
                | Q(publishing_linked__publication_end_date__lte=now())))
        # ...and exclude fields directly on published items
        queryset = queryset.exclude(
            Q(publishing_is_draft=False) & Q(
                Q(publication_date__gt=now())
                | Q(publication_end_date__lte=now())))

        return queryset


class UrlNodeQuerySetWithPublishingFeatures(UrlNodeQuerySet):
    """
    Customised `UrlNodeQuerySet` to impose our publishing API as much as
    possible on `UrlNode` models that are not based on our `PublishingModel`,
    which can be the situation for relationships to generic Fluent page types
    like `HtmlPage` or `Page` where the related items may or may not be
    instances of `PublishingModel`.
    """

    def published(self, for_user=None, force_exchange=True):
        """
        Customise `UrlNodeQuerySet.published()` to add filtering by publication
        date constraints and exchange of draft items for published ones.
        """
        qs = self._single_site()
        # Avoid filtering to only published items when we are in a draft
        # context and we know this method is triggered by Fluent (because
        # the `for_user` is present) because we may actually want to find
        # and return draft items to priveleged users in this situation.
        if for_user and is_draft_request_context():
            return qs

        if for_user is not None and for_user.is_staff:
            pass  # Don't filter by publication date for Staff
        else:
            qs = qs.filter(
                    Q(publication_date__isnull=True) |
                    Q(publication_date__lt=now())
                ).filter(
                    Q(publication_end_date__isnull=True) |
                    Q(publication_end_date__gte=now())
                )
        if force_exchange:
            return _exchange_for_published(qs)
        else:
            return qs.filter(status=UrlNode.PUBLISHED)

    def draft(self):
        return self.filter(status=UrlNode.DRAFT)

    def visible(self):
        return _queryset_visible(self)


PublishingManager = \
    models.Manager.from_queryset(PublishingQuerySet)
# Tell Django that related fields also need to use this manager
PublishingManager.use_for_related_fields = True


PublishingPolymorphicManager = \
    PolymorphicManager.from_queryset(PublishingPolymorphicQuerySet)


PublishingUrlNodeManager = \
    UrlNodeManager.from_queryset(PublishingUrlNodeQuerySet)
# We must override `UrlNodeManager`s `published` method here to ensure the
# version in our queryset takes precedence, otherwise invocations directly on
# `Model.objects` won't use our customised version.
PublishingUrlNodeManager.published = \
    lambda self, **kwargs: self.all().published(**kwargs)
