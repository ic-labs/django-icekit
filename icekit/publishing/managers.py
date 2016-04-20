from django.conf import settings
from django.db import models
from django.db.models.query import QuerySet
from django.db.models.query_utils import Q
from django.utils.timezone import now
from django.utils.translation import get_language
from fluent_pages.models.managers import UrlNodeQuerySet, UrlNodeManager
from model_utils.managers import PassThroughManagerMixin

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
        'get_draft_payload',
        'get_published',
        'get_visible',
        # NOTE: `get_draft` is not included here to discourage getting a draft
        'publishing_linked',
        'publishing_linked_id',
        'publishing_is_draft',
        'is_published',
        'has_been_published',
        'is_draft',
        'is_visible',
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


class PublishingQuerySet(QuerySet):
    """
    Base publishing queryset features, without UrlNode customisations.
    """

    def visible(self):
        """
        Return the visible version of publishable items, which means:
        - for privileged users: all draft items, whether published or not
        - for everyone else: the published copy of items.
        """
        if is_draft_request_context():
            # All draft objects, and only draft objects.
            return self.draft()
        else:
            return self.published()

    def draft(self):
        """
        Filter items to only those that are actually draft, though each draft
        item may or may not have an associated published version.

        In most cases this filter will do no real work, since we almost always
        deal with only draft versions when interacting with publishable items.
        """
        queryset = self.all()
        return queryset.filter(publishing_is_draft=True)

    def published(self, for_user=UNSET, with_exchange=True):
        """
        Filter items to include only those that are actually published.

        By default, this method will call ``exchange_for_published`` as the
        last step and will therefore return only the published object copies
        of published items. This is normally what you want, but it will make
        pre-existing query optimisations ineffective.

        If you want the original draft objects as well as their published
        copies, set ``with_exchange`` to ``False``. Please note that this will
        only return draft objects that have published copies.

        It should be noted that Fluent's notion of "published" items is
        different from ours and is user-sensitive such that privileged users
        actually see draft items as published. To make Fluent's notion of
        published items align with ours this method also acts as a shim for our
        ``visible`` filter and will return visible items when invoked by
        Fluent's view resolution process that provides the ``for_user`` kwarg.

        NOTE: Be aware that the queryset we are working with contains both
        draft and published items, so the filtering logic can be convoluted as
        it needs to handle both draft and published versions.
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
        # Exclude any draft items without a published copy. We keep all
        # published copy items, and draft items with a published copy. Result
        # can therefore contain both draft and published items, with both the
        # published and draft copies of published items.
        queryset = queryset.exclude(
            publishing_is_draft=True, publishing_linked=None)
        # Return the published item copies by default, or the original draft
        # copies if requested.
        if with_exchange:
            queryset = queryset.exchange_for_published()
        return queryset

    def exchange_for_published(self):
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
        for item in self:
            # If item is draft and has a linked published copy, use that...
            if item.publishing_is_draft and item.publishing_linked_id:
                published_version_pks.append(item.publishing_linked_id)
            # ...otherwise if item is already the published copy, use it.
            elif not item.publishing_is_draft:
                published_version_pks.append(item.pk)
        # TODO: Salvage more attributes from the original queryset, such as
        # `annotate()`, `distinct()`, `select_related()`, `values()`, etc.
        qs = self.model.objects.filter(pk__in=published_version_pks)
        # Restore ordering from original queryset.
        qs = self._order_by_pks(qs, published_version_pks)
        return qs

    def _order_by_pks(self, qs, pks):
        """
        Adjust the given queryset (*not* self) to order items according to the
        explicit ordering of PKs provided.

        This is a PostgreSQL-specific DB hack, based on:
        blog.mathieu-leplatre.info/django-create-a-queryset-from-a-list-preserving-order.html
        """
        pk_colname = '%s.%s' % (
            self.model._meta.db_table, self.model._meta.pk.column)
        clauses = ' '.join(
            ['WHEN %s=%s THEN %s' % (pk_colname, pk, i)
                for i, pk in enumerate(pks)]
        )
        ordering = 'CASE %s END' % clauses
        return qs.extra(
            select={'pk_ordering': ordering}, order_by=('pk_ordering',))

    def iterator(self):
        """
        Override default iterator to wrap returned items in a publishing
        sanity-checker "booby trap" to lazily raise an exception if DRAFT items
        are mistakenly returned and mis-used in a public context where only
        PUBLISHED items should be used.

        This booby trap is added when all of:

         - the DEBUG_PUBLISHING_ERRORS setting is unset or truthy
         - the publishing middleware is active, and therefore able to report
           accurately whether the request is in a drafts-permitted context
         - the publishing middleware tells us we are not in
           a drafts-permitted context, which means only published items
           should be used.
        """
        if getattr(settings, 'DEBUG_PUBLISHING_ERRORS', True) \
                and is_publishing_middleware_active() \
                and not is_draft_request_context():
            for item in super(PublishingQuerySet, self).iterator():
                if not item.publishing_is_draft:
                    yield item
                else:
                    yield DraftItemBoobyTrap(item)
        else:
            for item in super(PublishingQuerySet, self).iterator():
                yield item

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


class PublishingUrlNodeQuerySet(PublishingQuerySet, UrlNodeQuerySet):
    """
    Publishing queryset features with UrlNode support and customisations.
    """

    def published(self, for_user=UNSET, with_exchange=True):
        """
        Apply additional filtering of published items over that done in
        `PublishingQuerySet.published` to filter based on additional publising
        date fields used by Fluent.
        """
        if for_user is not UNSET:
            return self.visible()

        queryset = self.all()
        queryset = queryset.exclude(
            publishing_is_draft=True, publishing_linked=None)
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
        # Return the published item copies by default, or the original draft
        # copies if requested.
        if with_exchange:
            queryset = queryset.exchange_for_published()
        return queryset

    def get_for_path(self, path, language_code=None):
        """
        Return the UrlNode for the given path.
        The path is expected to start with an initial slash.

        Raises UrlNode.DoesNotExist when the item is not found.
        """
        if language_code is None:
            language_code = self._language or get_language()

        # Don't normalize slashes, expect the URLs to be sane.
        try:
            obj = self._single_site().get(
                translations___cached_url=path,
                translations__language_code=language_code,
                publishing_is_draft=is_draft_request_context(),
            )
            # Explicitly set language to the state the object was fetched in.
            obj.set_current_language(language_code)
            return obj
        except self.model.DoesNotExist:
            raise self.model.DoesNotExist(
                u"No published {0} found for the path '{1}'".format(
                    self.model.__name__, path))
        except self.model.MultipleObjectsReturned as e:
            # this is because storypage slugs can overlap. Just return the
            # first one with no category, or the last one if they all have
            # categories.
            objs = self._single_site().filter(
                translations___cached_url=path,
                translations__language_code=language_code,
                publishing_is_draft=is_draft_request_context(),
            )

            for obj in objs:
                try:
                    if not obj.category:
                        break
                except AttributeError:  # Shouldn't happen. Re-raise the error.
                    raise e

            obj.set_current_language(language_code)
            return obj


class PublishingManager(PassThroughManagerMixin, models.Manager):
    """
    Base publishing manager, without UrlNode customisations.
    """
    queryset_class = PublishingQuerySet
    # Tell Django that related fields also need to use this manager:
    use_for_related_fields = True

    def get_queryset(self):
        return PublishingQuerySet(self.model, using=self._db).all()


class PublishingUrlNodeManager(UrlNodeManager, PublishingManager):
    """
    Publishing manager with UrlNode support and customisations.
    """
    queryset_class = PublishingUrlNodeQuerySet
    # Tell Django that related fields also need to use this manager:
    use_for_related_fields = True

    # We must override UrlNodeManager's `published` method here to ensure the
    # version in our queryset takes precedence, otherwise invocations directly
    # on `Model.objects` can end up using `UrlNodeManager`s `published`
    # method instead of ours.
    def published(self, **kwargs):
        return self.all().published(**kwargs)
