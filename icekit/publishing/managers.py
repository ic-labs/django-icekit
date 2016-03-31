from copy import deepcopy
from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist, \
    MultipleObjectsReturned, FieldError
from django.db import models, transaction
from django.db.models.query import QuerySet
from django.db.models.query_utils import Q
from django.utils.timezone import now
from django.utils.translation import get_language
from fluent_contents.models import Placeholder
from fluent_pages import appsettings
from fluent_pages.models import UrlNode
from fluent_pages.models.managers import UrlNodeQuerySet, UrlNodeManager
from model_utils.managers import PassThroughManagerMixin

from . import signals
from .middleware import get_draft_status, get_middleware_active_status, \
    get_current_user
from .models import PublisherModel
from .utils import assert_draft


UNSET = object()  # Constant object to mark unset kwargs


class PublishingException(Exception):
    pass


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
        'publisher_linked',
        'publisher_linked_id',
        'publisher_is_draft',
        'is_published',
        'has_been_published',
        'is_draft',
        'is_visible',
    ]

    def __init__(self, payload):
        if not payload.publisher_is_draft:
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


def custom_publisher_pre_delete(sender, **kwargs):
    """
    Customised version of `publisher.signals.publisher_pre_delete` that avoids
    DoesNotExist errors in situations where an item's `publisher_linked`
    relationship target has been deleted, but the field value has not been
    reset to None -- a situation that can happen in reversion's temporary
    delete-in-transaction operation when restoring and viewing a prior version.

    TODO: Submit this as patch for django-model-publish project?
    """
    instance = kwargs.get('instance', None)
    if not instance:
        return

    # If the draft record is deleted, the published object should be as well
    # NOTE: Logic here varies slightly from original to guard for DoesNotExist
    if instance.publisher_is_draft:
        try:
            instance.publisher_linked.delete()
        except (ObjectDoesNotExist, AttributeError):
            pass


class PublisherQuerySet(QuerySet):
    """
    Base publisher queryset features, without UrlNode customisations.
    """

    def visible(self):
        """
        Return the visible version of publishable items, which means:
        - for privileged users: all draft items, whether published or not
        - for everyone else: the published copy of items.
        """
        if get_draft_status():
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
        return queryset.filter(publisher_is_draft=True)

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
            publisher_is_draft=True, publisher_linked=None)
        # Exclude by publication date on the published version of items, *not*
        # the draft vesion, or we could get the wrong result.
        # Exclude fields of published copy of draft items, not draft itself...
        queryset = queryset.exclude(
            Q(publisher_is_draft=True) & Q(
                Q(publisher_linked__publication_date__gt=now())
                | Q(publisher_linked__publication_end_date__lte=now())))
        # ...and exclude fields directly on published items
        queryset = queryset.exclude(
            Q(publisher_is_draft=False) & Q(
                Q(publication_date__gt=now())
                | Q(publication_end_date__lte=now())))
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
            if item.publisher_is_draft and item.publisher_linked_id:
                published_version_pks.append(item.publisher_linked_id)
            # ...otherwise if item is already the published copy, use it.
            elif not item.publisher_is_draft:
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
                and get_middleware_active_status() \
                and not get_draft_status():
            for item in super(PublisherQuerySet, self).iterator():
                if not item.publisher_is_draft:
                    yield item
                else:
                    yield DraftItemBoobyTrap(item)
        else:
            for item in super(PublisherQuerySet, self).iterator():
                yield item

    def only(self, *args, **kwargs):
        """
        Override default implementation to ensure that we *always* include the
        `publisher_is_draft` field when `only` is invoked, to avoid eternal
        recursion errors if `only` is called then we check for this item
        attribute in our custom `iterator`.

        Discovered the need for this by tracking down an eternal recursion
        error in the `only` query performed in
        fluent_pages.urlresolvers._get_pages_of_type
        """
        field_names = args
        if 'publisher_is_draft' not in field_names:
            field_names += ('publisher_is_draft',)
        return super(PublisherQuerySet, self) \
            .only(*field_names, **kwargs)


class PublisherUrlNodeQuerySet(PublisherQuerySet, UrlNodeQuerySet):
    """
    Publisher queryset features with UrlNode support and customisations.
    """

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
                publisher_is_draft=get_draft_status(),
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
                publisher_is_draft=get_draft_status(),
            )

            for obj in objs:
                try:
                    if not obj.category:
                        break
                except AttributeError:  # Shouldn't happen. Re-raise the error.
                    raise e

            obj.set_current_language(language_code)
            return obj


class PublisherManager(PassThroughManagerMixin, models.Manager):
    """
    Base publisher manager, without UrlNode customisations.
    """

    def contribute_to_class(self, model, name):
        super(PublisherManager, self).contribute_to_class(model, name)
        models.signals.pre_delete.connect(signals.publisher_pre_delete, model)

    def get_queryset(self):
        return PublisherQuerySet(self.model, using=self._db).all()


class PublisherUrlNodeManager(UrlNodeManager, PublisherManager):
    """
    Publisher manager with UrlNode support and customisations.
    """
    queryset_class = PublisherUrlNodeQuerySet

    # We must override UrlNodeManager's `published` method here to ensure the
    # version in our queryset takes precedence, otherwise invocations directly
    # on `Model.objects` can end up using `UrlNodeManager`s `published`
    # method instead of ours.
    def published(self, **kwargs):
        return self.all().published(**kwargs)


class PublisherContributeToClassManager(PublisherManager):
    """
    Publisher manager with `contribute_to_class` customisations to monkey-patch
    our attributes and methods into publishable models.
    """

    def contribute_to_class(self, model, name):
        super(PublisherContributeToClassManager, self) \
            .contribute_to_class(model, name)

        # Add these attributes to the class. These are attributes from
        # publisher to make it work.
        attributes = [
            'STATE_DRAFT',
            'STATE_PUBLISHED',

            'publisher_fields',
            'publisher_ignore_fields',
            'publisher_publish_empty_fields',

            'is_draft',
            'is_published',
            'is_dirty',
        ]

        for attr in attributes:
            model.add_to_class(attr, getattr(PublisherModel, attr))

        # Add these methods to the class. These are methods from publisher to
        # make it work.
        methods = [
            'get_placeholder_fields',
            'get_unique_together',
            'get_field',
        ]

        for attr in methods:
            setattr(
                model, attr,
                getattr(PublisherModel, attr).__get__(model, PublisherModel))

        # Add a publish method to the class.
        @assert_draft
        def publish(obj):
            """
            Publishes the object.

            The decorator `assert_draft` makes sure that you cannot publish
            a published object.
            :param obj: The object to tbe published.
            :return: The published object.
            """
            # Make sure that this object is dirty and a draft.
            if obj.is_draft and obj.is_dirty:
                # If the object has previously been linked then patch the placeholder data and
                # remove the previously linked object. Otherwise set the published date.
                if obj.publisher_linked:
                    obj.patch_placeholders(obj)
                    # Unlink draft and published copies then delete published.
                    # NOTE: This indirect dance is necessary to avoid
                    # triggering unwanted MPTT tree structure updates via
                    # `save`.
                    type(obj.publisher_linked).objects \
                        .filter(pk=obj.publisher_linked.pk) \
                        .delete()  # Instead of obj.publisher_linked.delete()
                else:
                    obj.publisher_published_at = now()

                # Create a new object copying all fields.
                publish_obj = deepcopy(obj)

                # If any fields are defined not to copy set them to None.
                for fld in obj.publisher_publish_empty_fields + (
                    'urlnode_ptr_id', 'publisher_linked_id'
                ):
                    setattr(publish_obj, fld, None)

                # Set the state of publication to published on the object.
                publish_obj.publisher_is_draft = False

                # Set the date the object should be published at.
                publish_obj.publisher_published_at = obj.publisher_published_at

                # Perform per-model preparation before saving published copy
                publish_obj.publishing_prepare_published_copy(obj)

                # Save the new published object as a separate instance to obj.
                publish_obj.save()
                # Sanity-check that we successfully saved the published copy
                if not publish_obj.pk:
                    raise PublishingException("Failed to save published copy")

                # As it is a new object we need to clone each of the translatable fields,
                # placeholders and required relations.
                obj.clone_translations(obj, publish_obj)
                obj.clone_placeholder(obj, publish_obj)
                obj.clone_relations(obj, publish_obj)

                # Extra relationship-cloning smarts
                publish_obj.publishing_clone_relations(obj)

                # Link the published object to the draft object.
                obj.publisher_linked = publish_obj

                # Flag draft instance when it is being updated as part of a
                # publish action, for use in `publisher_set_update_time`
                obj._skip_update_publisher_modified_at = True

                # Signal the pre-save hook for publication, save then signal the post publish hook.
                signals.publisher_publish_pre_save_draft.send(sender=type(obj), instance=obj)

                # Save the change and create a revision to mark the change.
                self.publishing_save_draft_after_publish(obj)

                signals.publisher_post_publish.send(sender=type(obj), instance=obj)
                return publish_obj
        model.publish = publish

        def publishing_save_draft_after_publish(self, draft_obj):
            """
            Save draft object after it has been published. We do this in this
            method to make it easier to override the save to do things like
            create a revision when an item is published.
            """
            draft_obj.save()

        def publishing_prepare_published_copy(self, draft_obj):
            """ Prepare published copy of draft prior to saving it """
            pass

        if not hasattr(model, 'publishing_prepare_published_copy'):
            model.publishing_prepare_published_copy = publishing_prepare_published_copy

        def publishing_clone_relations(self, draft_obj):
            """
            Clone forward and reverse M2Ms.

            This code is difficult to follow because the logic it applies is
            confusing, but here is a summary that might help:

             - when a draft object is published, the "current" and definitive
               relationships are cloned to the published copy. The definitive
               relationships are the draft-to-draft ones, as set in the admin.
             - a "related draft" is the draft object at the other side of
               a draft-to-draft M2M relationship
             - if a related draft also has a published copy, a draft-to-
               published relationship is added to that published copy. This
               makes our newly-published item also "published" from the reverse
               direction
             - if our draft object has a related published copy without a
               correponding related draft -- that is, a draft-to-published
               relation without a definitive draft-to-draft relation -- then
               we remove that relation as it is no longer "current". This
               makes our newly-published item "unpublished" from the reverse
               direction when an admin removes the underlying relationship.

            An example case:

             - We have Event "E" (unpublished) and Program "P" (published)
             - We add an M2M relationship from E to P. Until the relationship
               change is published it only affects drafts. Relationships are:
                 E draft <-> P draft
             - We publish E, applying the relationship to published copies on
               both sides:
                 E draft <-> P draft
                 E published <-> P draft
                 P published <-> E draft
             - We remove the M2M relationship between E and P (We could do this
               from either side: remove E from P; or, remove P from E). The
               draft-to-draft relation is removed but published copy
               relationships are not affected:
                 E published <-> P draft
                 P published <-> E draft
             - We publish P (or E) to apply the relationshp removal to
               published copies on both sides. No relationships remain.

            See unit test ``.test_m2m_handling_in_publishing_clone_relations``
            in ``sfmoma.tests.tests.TestPagePublishing``
            """
            def clone(src, dst):
                published_rel_obj_copies_to_add = []
                published_rel_objs_maybe_obsolete = []
                for rel_obj in src.all():
                    # If the object referenced by the M2M is publishable we
                    # clone it only if it is a draft copy. If it is not a
                    # publishable object we also clone it (True by default).
                    if getattr(rel_obj, 'publisher_is_draft', True):
                        dst.add(rel_obj)
                        # If the related object also has a published copy, we
                        # need to make sure the published copy also knows about
                        # this newly-published draft. We defer this until below
                        # when we are no longer iterating over the queryset
                        # we need to modify.
                        try:
                            if rel_obj.publisher_linked:
                                published_rel_obj_copies_to_add.append(
                                    rel_obj.publisher_linked)
                        except AttributeError:
                            pass  # No `publisher_linked` attr to handle
                    else:
                        # Track related published copies, in case they have
                        # become obsolete
                        published_rel_objs_maybe_obsolete.append(rel_obj)
                # Make published copies of related objects aware of our
                # newly-published draft, in case they weren't already.
                if published_rel_obj_copies_to_add:
                    src.add(*published_rel_obj_copies_to_add)
                # If related published copies have no corresponding related
                # draft after all the previous processing, the relationship is
                # obsolete and must be removed.
                current_draft_rel_pks = set([
                    i.pk for i in src.all() if getattr(i, 'is_draft', False)
                ])
                for published_rel_obj in published_rel_objs_maybe_obsolete:
                    draft = published_rel_obj.get_draft()
                    if not draft or draft.pk not in current_draft_rel_pks:
                        src.remove(published_rel_obj)
            # Track the relationship through-tables we have processed to avoid
            # processing the same relationships in both forward and reverse
            # directions, which could otherwise happen in unusual cases like
            # for SFMOMA event M2M inter-relationships which are explicitly
            # defined both ways as a hack to expose form widgets.
            seen_rel_through_tables = set()
            # Forward.
            for field in draft_obj._meta.many_to_many:
                src = getattr(draft_obj, field.name)
                dst = getattr(self, field.name)
                clone(src, dst)
                seen_rel_through_tables.add(field.rel.through)
            # Reverse.
            for field in \
                    draft_obj._meta.get_all_related_many_to_many_objects():
                # Skip reverse relationship if we have already seen, see note
                # about `seen_rel_through_tables` above.
                if field.field.rel.through in seen_rel_through_tables:
                    continue
                field_accessor_name = field.get_accessor_name()
                # M2M relationships with `self` don't have accessor names
                if not field_accessor_name:
                    continue
                src = getattr(draft_obj, field_accessor_name)
                dst = getattr(self, field_accessor_name)
                clone(src, dst)

        model.publishing_clone_relations = publishing_clone_relations

        @assert_draft
        def patch_placeholders(obj, draft_obj):
            """
            This is a patched version from `publisher`.

            The arguments have been kept consistent with the
            `publisher` even though it does not make that much sense.
            """
            published_obj = draft_obj.publisher_linked

            for draft_placeholder, published_placeholder in zip(
                    Placeholder.objects.parent(draft_obj),
                    Placeholder.objects.parent(published_obj)
            ):
                if draft_placeholder.pk == published_placeholder.pk:
                    published_placeholder.pk = None
                    published_placeholder.save()

        model.patch_placeholders = patch_placeholders

        @assert_draft
        def unpublish(obj):
            """
            Un-publish the current object.
            """
            if obj.is_draft and obj.publisher_linked:
                signals.publisher_pre_unpublish.send(sender=type(obj), instance=obj)
                # Unlink draft and published copies then delete published.
                # NOTE: This indirect dance is necessary to avoid triggering
                # unwanted MPTT tree structure updates via `delete`.
                type(obj.publisher_linked).objects \
                    .filter(pk=obj.publisher_linked.pk) \
                    .delete()  # Instead of obj.publisher_linked.delete()
                # NOTE: We update and save the object *after* deleting the
                # published version, in case the `save()` method does some
                # validation that breaks when unlinked published objects exist.
                obj.publisher_linked = None
                obj.publisher_published_at = None
                obj.save()
                # Save the change and create a revision to mark the change.
                with transaction.atomic(), reversion.create_revision():
                    obj.save()
                    reversion.set_user(get_current_user())
                    reversion.set_comment('Unpublished')
                signals.publisher_post_unpublish.send(sender=type(obj), instance=obj)

        model.unpublish = unpublish

        @assert_draft
        def revert_to_public(obj):
            """
            Revert draft instance to the last published instance.
            """
            if obj.publisher_linked:
                version = reversion.get_for_object(obj) \
                    .filter(revision__comment='Published') \
                    .latest('revision__date_created')
                version.revision.revert()
                draft_obj = version.object
                with transaction.atomic(), reversion.create_revision():
                    draft_obj.save()
                    reversion.set_user(get_current_user())
                    reversion.set_comment('Reverted to last published.')
                return draft_obj

        model.revert_to_public = revert_to_public

        @staticmethod
        def clone_translations(src_obj, dst_obj):
            """
            Clone each of the translations from an object and relate
            them to another.
            :param src_obj: The object to get the translations from.
            :param dst_obj: The object to relate the new translations to.
            :return: None
            """
            # Find all django-parler translation attributes on model
            translation_attrs = []
            if hasattr(model, '_parler_meta'):
                for parler_meta in model._parler_meta:
                    translation_attrs.append(parler_meta.rel_name)
            # Clone all django-parler translations via attributes
            for translation_attr in translation_attrs:
                # Clear any translations already cloned to published object
                # before we get here, which seems to happen via deepcopy()
                # sometimes.
                setattr(dst_obj, translation_attr, [])
                # Clone attribute's translations from source to destination
                for translation in getattr(src_obj, translation_attr).all():
                    translation.pk = None
                    translation.master = dst_obj
                    translation.save()

        model.clone_translations = clone_translations

        def clone_placeholder(obj, src_obj, dst_obj):
            """
            Clone each of the placeholder items.

            The arguments have been kept consistent with the
            `publisher` even though `obj` is not required.

            :param obj: The object which does not get used...
            :param src_obj: The object for which the placeholders are
            to be cloned from.
            :param dst_obj: The object which the cloned placeholders
            are to be related.
            :return: None
            """
            for src_placeholder in Placeholder.objects.parent(src_obj):
                dst_placeholder = Placeholder.objects.create_for_object(
                    dst_obj,
                    slot=src_placeholder.slot,
                    role=src_placeholder.role,
                    title=src_placeholder.title
                )

                src_items = src_placeholder.get_content_items()
                src_items.copy_to_placeholder(dst_placeholder)

        model.clone_placeholder = clone_placeholder

        def clone_relations(cls, src_obj, dst_obj):
            """
            Find all MTM relationships on related ContentItem's and ensure the
            published M2M relationships directed back to the draft (src)
            content items are maintained for the published (dst) page's content
            items.
            """
            # NOTE: We assume here that src & dst content item set is the same
            # number and in the same order: we don't really have a better way
            # to figure out which destination content item corresponds to which
            # source content item. Hopefully this assumption holds...
            if not hasattr(src_obj, 'contentitem_set'):
                return
            for src_ci, dst_ci in zip(src_obj.contentitem_set.all(),
                                      dst_obj.contentitem_set.all()):
                for field, __ in src_ci._meta.get_m2m_with_model():
                    field_name = field.name
                    src_m2m = getattr(src_ci, field_name)
                    dst_m2m = getattr(dst_ci, field_name)

                    # It is safe to just `add` here, rather than match src and
                    # dst listing exactly (i.e. potentially delete or re-order
                    # items) because the destination content items are
                    # re-created on publish thus always have empty M2M rels.
                    dst_m2m.add(*src_m2m.all())

        model.clone_relations = clone_relations

        def _make_slug_unique(obj, translation):
            """
            Custom make slug unique checked.
            :param obj: The object to which the slug is or will be
            associated.
            :param translation: The particular translation of the slug.
            :return: None
            """
            original_slug = translation.slug
            count = 1
            while True:
                exclude_kwargs = {
                    'pk__in': [],
                }
                if obj:
                    exclude_kwargs['pk__in'].append(obj.pk)

                if obj.publisher_linked_id:
                    exclude_kwargs['pk__in'].append(obj.publisher_linked_id)

                url_nodes = UrlNode.objects.filter(
                    parent=obj.parent_id,
                    translations__slug=translation.slug,
                    translations__language_code=translation.language_code
                ).exclude(**exclude_kwargs).non_polymorphic()

                if appsettings.FLUENT_PAGES_FILTER_SITE_ID:
                    url_nodes = url_nodes.parent_site(obj.parent_site_id)

                if not url_nodes.exists():
                    break

                count += 1
                translation.slug = '%s-%d' % (original_slug, count)

        model._make_slug_unique = _make_slug_unique

        def get_published(obj):
            """
            Return self is this object is published, otherwise return the
            published copy of a draft item. If this object is a draft with
            no published copy it will return ``None``.
            """
            if obj.is_published:
                return obj
            elif obj.is_draft:
                return obj.publisher_linked
            raise ValueError(
                "Publishable object %r is neither draft nor published" % obj)

        model.get_published = get_published

        @property
        def has_been_published(obj):
            """
            Return True if the item is either published itself, or has an
            associated published copy.

            This is in contrast to ``is_published`` which only returns True if
            the specific object is a published copy, and will return False for
            a draft object that has an associated published copy.
            """
            if obj.is_published:
                return True
            elif obj.is_draft:
                return obj.publisher_linked is not None
            raise ValueError(
                "Publishable object %r is neither draft nor published" % obj)

        model.has_been_published = has_been_published

        def get_draft(obj):
            """
            Return self if this object is a draft, otherwise return the draft
            copy of a published item.
            """
            if obj.is_draft:
                return obj
            elif obj.is_published:
                return obj.publisher_draft
            raise ValueError(
                "Publishable object %r is neither draft nor published" % obj)

        model.get_draft = get_draft

        def get_visible(obj):
            """
            Return the visible version of publishable items, which means:
            - for privileged users: a draft items, whether published or not
            - for everyone else: the published copy of items.
            """
            if get_draft_status():
                return obj.get_draft()
            else:
                return obj.get_published()

        model.get_visible = get_visible

        @property
        def is_visible(obj):
            """
            Return True if the item is the visible according to the request
            context:
            - for privileged users: is a draft item
            - for everyone else: is a published item
            """
            if not get_draft_status():
                return obj.is_published
            else:
                return obj.is_draft

        model.is_visible = is_visible

        def HACK_MPTT_get_root(self):
            """
            Replace default implementation of `mptt.models.MPTTModel.get_root`
            with a version that returns the root of either published or draft
            items, as appropriate for this item.

            In other words: return the published root if this item is
            published; return the draft root if this item is a draft.
            """
            if self.is_root_node() \
                    and type(self) == self._tree_manager.tree_model:
                return self

            root_qs = self._tree_manager._mptt_filter(
                tree_id=self._mpttfield('tree_id'),
                parent=None,
            )
            # Try normal approach first, in case it works
            try:
                return root_qs.get()
            except MultipleObjectsReturned:
                # Nope, we got both draft and published copies as root
                pass

            # Sort out this mess manually by grabbing the first root candidate
            # and converting it to draft or published copy as appropriate.
            if self.publisher_is_draft:
                return root_qs.first().get_draft()
            else:
                return root_qs.first().get_published()

        # Replace MPTT's `get_root` implementation if it's present
        if hasattr(model, 'get_root'):
            model.get_root = HACK_MPTT_get_root

        def HACK_MPTT_get_descendants(self, include_self=False,
                                      ignore_publish_status=False):
            """
            Replace `mptt.models.MPTTModel.get_descendants` with a version that
            returns only draft or published copy descendants, as appopriate.
            """
            qs = self._original_get_descendants(include_self=include_self)
            if not ignore_publish_status:
                try:
                    qs = qs.filter(publisher_is_draft=self.publisher_is_draft)
                except FieldError:
                    pass  # Likely an unpublishable polymorphic parent
            return qs

        # Replace MPTT's `get_descendants` implementation if it's present
        if hasattr(model, 'get_descendants'):
            model._original_get_descendants = model.get_descendants
            model.get_descendants = HACK_MPTT_get_descendants

        def HACK_MPTT_get_ancestors(self, ascending=False, include_self=False,
                                    ignore_publish_status=False):
            """
            Replace `mptt.models.MPTTModel.get_ancestors` with a version that
            returns only draft or published copy ancestors, as appopriate.
            """
            qs = self._original_get_ancestors(
                ascending=ascending, include_self=include_self)
            if not ignore_publish_status:
                try:
                    qs = qs.filter(publisher_is_draft=self.publisher_is_draft)
                except FieldError:
                    pass  # Likely an unpublishable polymorphic parent
            return qs

        # Replace MPTT's `get_ancestors` implementation if it's present
        if hasattr(model, 'get_ancestors'):
            model._original_get_ancestors = model.get_ancestors
            model.get_ancestors = HACK_MPTT_get_ancestors

        models.signals.pre_delete.connect(custom_publisher_pre_delete, model)
