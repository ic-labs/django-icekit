from copy import deepcopy

from django.contrib.auth.models import Permission
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.core.exceptions import ObjectDoesNotExist
from django.db import models
from django.dispatch import receiver
from django.utils import timezone

from fluent_contents.models import Placeholder
from fluent_pages.models import UrlNode
from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.mixins import FluentFieldsMixin

from .managers import PublishingManager, PublishingUrlNodeManager
from .middleware import is_draft_request_context
from .utils import PublishingException, assert_draft, \
    is_automatic_publishing_enabled
from . import signals as publishing_signals


class PublishingModel(models.Model):
    """
    Model fields and features to implement publishing.
    """
    objects = PublishingManager()
    _default_manager = PublishingManager()

    publishing_linked = models.OneToOneField(
        'self',
        related_name='publishing_draft',
        null=True,
        editable=False,
        on_delete=models.SET_NULL)
    publishing_is_draft = models.BooleanField(
        default=True,
        editable=False,
        db_index=True)
    publishing_modified_at = models.DateTimeField(
        default=timezone.now,
        editable=False)
    publishing_published_at = models.DateTimeField(
        null=True, editable=False)

    publishing_fields = (
        'publishing_linked',
        'publishing_is_draft',
        'publishing_modified_at',
        'publishing_draft',
    )
    publishing_ignore_fields = publishing_fields + (
        'pk',
        'id',
        'publishing_linked',
    )
    publishing_publish_empty_fields = (
        'pk',
        'id',
    )

    class Meta:
        abstract = True
        permissions = (
            ('can_publish', 'Can publish'),
            ('can_republish', 'Can republish'),
        )

    @property
    def is_dirty(self):
        if not self.is_draft:
            return False

        # If the record has not been published assume dirty
        if not self.publishing_linked:
            return True

        if self.publishing_modified_at \
                > self.publishing_linked.publishing_modified_at:
            return True

        # Get all placeholders + their plugins to find their modified date
        for placeholder_field in self.get_cms_placeholder_fields():
            placeholder = getattr(self, placeholder_field)
            for plugin in placeholder.get_plugins_list():
                if plugin.changed_date \
                        > self.publishing_linked.publishing_modified_at:
                    return True
        return False

    @property
    def is_draft(self):
        return self.publishing_is_draft

    @property
    def is_published(self):
        return not self.publishing_is_draft

    @property
    def is_visible(self):
        """
        Return True if the item is the visible according to the request
        context:
        - for privileged users: is a draft item
        - for everyone else: is a published item
        """
        if not is_draft_request_context():
            return self.is_published
        else:
            return self.is_draft

    def is_within_publication_dates(obj, timestamp=None):
        """
        Return True if the given timestamp (or ``now()`` by default) is
        witin any publication start/end date constraints.
        """
        if timestamp is None:
            timestamp = timezone.now()
        start_date_ok = not obj.publication_date \
            or obj.publication_date <= timestamp
        end_date_ok = not obj.publication_end_date \
            or obj.publication_end_date > timestamp
        return start_date_ok and end_date_ok

    @property
    def has_been_published(self):
        """
        Return True if the item is either published itself, or has an
        associated published copy.

        This is in contrast to ``is_published`` which only returns True if
        the specific object is a published copy, and will return False for
        a draft object that has an associated published copy.
        """
        if self.is_published:
            return True
        elif self.is_draft:
            return self.publishing_linked_id is not None
        raise ValueError(  # pragma: no cover
            "Publishable object %r is neither draft nor published" % self)

    def get_draft(self):
        """
        Return self if this object is a draft, otherwise return the draft
        copy of a published item.
        """
        if self.is_draft:
            return self
        elif self.is_published:
            draft = self.publishing_draft
            # Previously the reverse relation could be `DraftItemBoobyTrapped`
            # in some cases. This should be fixed by extra monkey-patching of
            # the `publishing_draft` field in icekit.publishing.apps, but we
            # will leave this extra sanity check here just in case.
            if hasattr(draft, 'get_draft_payload'):
                draft = draft.get_draft_payload()
            return draft
        raise ValueError(  # pragma: no cover
            "Publishable object %r is neither draft nor published" % self)

    def get_published(self):
        """
        Return self is this object is published, otherwise return the
        published copy of a draft item. If this object is a draft with
        no published copy it will return ``None``.
        """
        if self.is_published:
            return self
        elif self.is_draft:
            return self.publishing_linked
        raise ValueError(  # pragma: no cover
            "Publishable object %r is neither draft nor published" % self)

    def get_visible(self):
        """
        Return the visible version of publishable items, which means:
        - for privileged users: a draft items, whether published or not
        - for everyone else: the published copy of items.
        """
        if is_draft_request_context():
            return self.get_draft()
        else:
            return self.get_published()

    def get_published_or_draft(self):
        """
        Return the published item, if it exists, otherwise, for privileged
        users, return the draft version.
        """
        if self.is_published:
            return self
        elif self.publishing_linked_id:
            return self.publishing_linked
        if is_draft_request_context():
            return self.get_draft()
        # There is no public version, and there is no privilege to view the
        # draft version
        return None

    def get_unique_together(self):
        return self._meta.unique_together

    def get_field(self, field_name):
        # return the actual field (not the db representation of the field)
        try:
            return self._meta.get_field_by_name(field_name)[0]
        except models.fields.FieldDoesNotExist:
            return None

    def get_cms_placeholder_fields(self, obj=None):
        try:
            from cms.models.placeholdermodel import Placeholder
            return self.get_placeholder_fields(Placeholder, obj=obj)
        except ImportError:
            return []

    def get_placeholder_fields(self, placeholder_class, obj=None):
        if obj is None:
            obj = self

        placeholder_fields = []
        model_fields = obj.__class__._meta.get_all_field_names()
        for field in model_fields:
            if field in self.publishing_ignore_fields:
                continue

            try:
                placeholder = getattr(obj, field)
                if isinstance(placeholder, Placeholder):
                    placeholder_fields.append(field)
            except (ObjectDoesNotExist, AttributeError):
                continue
        return placeholder_fields

    @assert_draft
    def publish(self):
        """
        Publishes the object.

        The decorator `assert_draft` makes sure that you cannot publish
        a published object.
        :param self: The object to tbe published.
        :return: The published object.
        """
        if self.is_draft:
            # If the object has previously been linked then patch the
            # placeholder data and remove the previously linked object.
            # Otherwise set the published date.
            if self.publishing_linked:
                self.patch_placeholders()
                # Unlink draft and published copies then delete published.
                # NOTE: This indirect dance is necessary to avoid
                # triggering unwanted MPTT tree structure updates via
                # `save`.
                type(self.publishing_linked).objects \
                    .filter(pk=self.publishing_linked.pk) \
                    .delete()  # Instead of self.publishing_linked.delete()
            else:
                self.publishing_published_at = timezone.now()

            # Create a new object copying all fields.
            publish_obj = deepcopy(self)

            # If any fields are defined not to copy set them to None.
            for fld in self.publishing_publish_empty_fields + (
                'urlnode_ptr_id', 'publishing_linked_id'
            ):
                setattr(publish_obj, fld, None)

            # Set the state of publication to published on the object.
            publish_obj.publishing_is_draft = False

            # Update Fluent's publishing status field mechanism to correspond
            # to our own notion of publication, to help use work together more
            # easily with Fluent Pages.
            if isinstance(self, UrlNode):
                self.status = UrlNode.DRAFT
                publish_obj.status = UrlNode.PUBLISHED

            # Set the date the object should be published at.
            publish_obj.publishing_published_at = self.publishing_published_at

            # Perform per-model preparation before saving published copy
            publish_obj.publishing_prepare_published_copy(self)

            # Save the new published object as a separate instance to self.
            publish_obj.save()
            # Sanity-check that we successfully saved the published copy
            if not publish_obj.pk:  # pragma: no cover
                raise PublishingException("Failed to save published copy")

            # As it is a new object we need to clone each of the
            # translatable fields, placeholders and required relations.
            self.clone_parler_translations(publish_obj)
            self.clone_fluent_placeholders_and_content_items(publish_obj)
            self.clone_fluent_contentitems_m2m_relationships(publish_obj)

            # Extra relationship-cloning smarts
            publish_obj.publishing_clone_relations(self)

            # Link the published object to the draft object.
            self.publishing_linked = publish_obj

            # Flag draft instance when it is being updated as part of a
            # publish action, for use in `publishing_set_update_time`
            self._skip_update_publishing_modified_at = True

            # Signal the pre-save hook for publication, save then signal
            # the post publish hook.
            publishing_signals.publishing_publish_pre_save_draft.send(
                sender=type(self), instance=self)

            # Save the draft and its new relationship with the published copy
            publishing_signals.publishing_publish_save_draft.send(
                sender=type(self), instance=self)

            publishing_signals.publishing_post_publish.send(
                sender=type(self), instance=self)
            return publish_obj

    @assert_draft
    def unpublish(self):
        """
        Un-publish the current object.
        """
        if self.is_draft and self.publishing_linked:
            publishing_signals.publishing_pre_unpublish.send(
                sender=type(self), instance=self)
            # Unlink draft and published copies then delete published.
            # NOTE: This indirect dance is necessary to avoid triggering
            # unwanted MPTT tree structure updates via `delete`.
            type(self.publishing_linked).objects \
                .filter(pk=self.publishing_linked.pk) \
                .delete()  # Instead of self.publishing_linked.delete()
            # NOTE: We update and save the object *after* deleting the
            # published version, in case the `save()` method does some
            # validation that breaks when unlinked published objects exist.
            self.publishing_linked = None
            self.publishing_published_at = None

            # Save the draft to remove its relationship with the published copy
            publishing_signals.publishing_unpublish_save_draft.send(
                sender=type(self), instance=self)

            publishing_signals.publishing_post_unpublish.send(
                sender=type(self), instance=self)

    @assert_draft
    def revert_to_public(self):
        """
        Revert draft instance to the last published instance.
        """
        raise Exception(
            "TODO: Re-implement revert-to-public without reversion?")

    def publishing_prepare_published_copy(self, draft_obj):
        """ Prepare published copy of draft prior to saving it """
        # We call super here, somewhat perversely, to ensure this method will
        # be called on publishable subclasses if implemented there.
        mysuper = super(PublishingModel, self)
        if hasattr(mysuper, 'publishing_prepare_published_copy'):
            mysuper.publishing_prepare_published_copy(draft_obj)

    def publishing_clone_relations(self, src_obj):
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

        To handle M2M relationships in general we iterate over entries in the
        through-table relationship table to clone these entries, or remove
        them, as appropriate. By processing the M2M relationships in this way
        we can handle both kinds of M2M relationship:

            - standard M2M relationships with no explicit through table defined
              (these get an auto-generated through table) which are easier to
              handle because we can add/remove items with the relationship's
              queryset directly
            - M2M relationships with an explicit through table defined, which
              are more difficult to handle because we must use the through
              model's manager to add/remove relationships.

        See unit tests in ``TestPublishingOfM2MRelationships``.
        """

        def clone_through_model_relationship(
                manager, through_entry, dst_obj, rel_obj
        ):
            dst_obj_filter = build_filter_for_through_field(
                manager, manager.source_field_name, dst_obj)
            rel_obj_filter = build_filter_for_through_field(
                manager, manager.target_field_name, rel_obj)
            if manager.through.objects \
                    .filter(**dst_obj_filter) \
                    .filter(**rel_obj_filter) \
                    .exists():
                return
            through_entry.pk = None
            setattr(through_entry, manager.source_field_name, dst_obj)
            setattr(through_entry, manager.target_field_name, rel_obj)
            through_entry.save()

        def delete_through_model_relationship(manager, src_obj, dst_obj):
            src_obj_filter = build_filter_for_through_field(
                manager, manager.source_field_name, src_obj)
            dst_obj_filter = build_filter_for_through_field(
                manager, manager.target_field_name, dst_obj)
            manager.through.objects \
                .filter(**src_obj_filter) \
                .filter(**dst_obj_filter) \
                .delete()

        def build_filter_for_through_field(manager, field_name, obj):
            # If the field is a `GenericForeignKey` we need to build
            # a compatible filter dict against the field target's content type
            # and PK...
            field = getattr(manager.through, field_name)
            if isinstance(field, GenericForeignKey):
                field_filter = {
                    getattr(field, 'fk_field'): obj.pk,
                    getattr(field, 'ct_field'):
                        ContentType.objects.get_for_model(obj)
                }
            # ...otherwise standard FK fields can be handled simply
            else:
                field_filter = {field_name: obj}
            return field_filter

        def clone(src_manager):
            if (
                not hasattr(src_manager, 'source_field_name') or
                not hasattr(src_manager, 'target_field_name')
            ):
                raise PublishingException(
                    "Publishing requires many-to-many managers to have"
                    " 'source_field_name' and 'target_field_name' attributes"
                    " with the source and target field names that relate the"
                    " through model to the ends of the M2M relationship."
                    " If a non-standard manager does not provide these"
                    " attributes you must add them."
                )

            src_obj_source_field_filter = build_filter_for_through_field(
                src_manager, src_manager.source_field_name, src_obj)
            through_qs = src_manager.through.objects \
                .filter(**src_obj_source_field_filter)
            published_rel_objs_maybe_obsolete = []
            current_draft_rel_pks = set()
            for through_entry in through_qs:
                rel_obj = getattr(through_entry, src_manager.target_field_name)
                # If the object referenced by the M2M is publishable we only
                # clone the relationship if it is to a draft copy, not if it is
                # to a published copy. If it is not a publishable object at
                # all then we always clone the relationship (True by default).
                if getattr(rel_obj, 'publishing_is_draft', True):
                    clone_through_model_relationship(
                        src_manager, through_entry, self, rel_obj)
                    # If the related draft object also has a published copy,
                    # we need to make sure the published copy also knows about
                    # this newly-published draft.
                    try:
                        # Get published copy for related object, if any
                        rel_obj_published = rel_obj.publishing_linked
                    except AttributeError:
                        pass  # Related item has no published copy
                    else:
                        if rel_obj_published:
                            clone_through_model_relationship(
                                src_manager, through_entry,
                                src_obj, rel_obj_published)
                    # Track IDs of related draft copies, so we can tell later
                    # whether relationshps with published copies are obsolete
                    current_draft_rel_pks.add(rel_obj.pk)
                else:
                    # Track related published copies, in case they have
                    # become obsolete
                    published_rel_objs_maybe_obsolete.append(rel_obj)
            # If related published copies have no corresponding related
            # draft after all the previous processing, the relationship is
            # obsolete and must be removed.
            for published_rel_obj in published_rel_objs_maybe_obsolete:
                draft = published_rel_obj.get_draft()
                if not draft or draft.pk not in current_draft_rel_pks:
                    delete_through_model_relationship(
                        src_manager, src_obj, published_rel_obj)

        # Track the relationship through-tables we have processed to avoid
        # processing the same relationships in both forward and reverse
        # directions, which could otherwise happen in unusual cases like
        # for SFMOMA event M2M inter-relationships which are explicitly
        # defined both ways as a hack to expose form widgets.
        seen_rel_through_tables = set()

        # Forward.
        for field in src_obj._meta.many_to_many:
            src_manager = getattr(src_obj, field.name)
            clone(src_manager)
            seen_rel_through_tables.add(field.rel.through)

        # Reverse.
        for field in src_obj._meta.get_all_related_many_to_many_objects():
            # Skip reverse relationship we have already seen
            if field.field.rel.through in seen_rel_through_tables:
                continue
            field_accessor_name = field.get_accessor_name()
            # M2M relationships with `self` don't have accessor names
            if not field_accessor_name:
                continue
            src_manager = getattr(src_obj, field_accessor_name)
            clone(src_manager)

    def has_placeholder_relationships(self):
        return hasattr(self, 'placeholder_set') \
            or hasattr(self, 'placeholders') \
            or len(self.get_placeholder_fields(Placeholder)) > 0

    @assert_draft
    def patch_placeholders(self):
        if not self.has_placeholder_relationships():
            return

        published_obj = self.publishing_linked

        for draft_placeholder, published_placeholder in zip(
                Placeholder.objects.parent(self),
                Placeholder.objects.parent(published_obj)
        ):
            if draft_placeholder.pk == published_placeholder.pk:
                published_placeholder.pk = None
                published_placeholder.save()

    def clone_parler_translations(self, dst_obj):
        """
        Clone each of the translations from an object and relate
        them to another.
        :param self: The object to get the translations from.
        :param dst_obj: The object to relate the new translations to.
        :return: None
        """
        # Find all django-parler translation attributes on model
        translation_attrs = []
        if hasattr(self, '_parler_meta'):
            for parler_meta in self._parler_meta:
                translation_attrs.append(parler_meta.rel_name)
        # Clone all django-parler translations via attributes
        for translation_attr in translation_attrs:
            # Clear any translations already cloned to published object
            # before we get here, which seems to happen via deepcopy()
            # sometimes.
            setattr(dst_obj, translation_attr, [])
            # Clone attribute's translations from source to destination
            for translation in getattr(self, translation_attr).all():
                translation.pk = None
                translation.master = dst_obj
                translation.save()

    def clone_fluent_placeholders_and_content_items(self, dst_obj):
        """
        Clone each `Placeholder` and its `ContentItem`s.

        :param self: The object for which the placeholders are
        to be cloned from.
        :param dst_obj: The object which the cloned placeholders
        are to be related.
        :return: None
        """
        if not self.has_placeholder_relationships():
            return

        for src_placeholder in Placeholder.objects.parent(self):
            dst_placeholder = Placeholder.objects.create_for_object(
                dst_obj,
                slot=src_placeholder.slot,
                role=src_placeholder.role,
                title=src_placeholder.title
            )

            src_items = src_placeholder.get_content_items()
            src_items.copy_to_placeholder(dst_placeholder)

    def clone_fluent_contentitems_m2m_relationships(self, dst_obj):
        """
        Find all MTM relationships on related ContentItem's and ensure the
        published M2M relationships directed back to the draft (src)
        content items are maintained for the published (dst) page's content
        items.
        """
        if not hasattr(self, 'contentitem_set'):
            return
        # We must explicitly and reliably order both the src and dst content
        # items here to ensure that we are processing the same logical item for
        # the draft and published copies. The default `ContentItem` ordering of
        # ('placeholder', 'sort_order') is not sufficient because it relies on
        # the placeholder PK remaining static, whereas we clone placeholders to
        # the published copy and may sometimes clone them with PKs in a
        # different order.
        reliable_ordering = [
            # Group items by owning placeholder using slot name, not PK
            'placeholder__slot',
            # Order items correctly within the placeholder grouping
            'sort_order'
        ]
        for src_ci, dst_ci in zip(
            self.contentitem_set.order_by(*reliable_ordering),
            dst_obj.contentitem_set.order_by(*reliable_ordering)
        ):
            for field, __ in src_ci._meta.get_m2m_with_model():
                field_name = field.name
                src_m2m = getattr(src_ci, field_name)
                dst_m2m = getattr(dst_ci, field_name)

                # It is safe to just `add` here, rather than match src and
                # dst listing exactly (i.e. potentially delete or re-order
                # items) because the destination content items are
                # re-created on publish thus always have empty M2M rels.
                dst_m2m.add(*src_m2m.all())

    def suppressed_message(self):
        """
        Occasionally items may not be visible to the public even if they have
        been published and can be previewed. For example, if they belong to a
        parent who is not published.

        In that case, returning a string here will result in a red `published`
        indicator in admin, and the string will be shown in the hyperlink
        title.

        :return: A message to be shown to the user only if the content can be
        previewed but not published.
        """
        return None


class PublishableFluentContentsPage(FluentContentsPage, PublishingModel):
    """
    Basic Page subtype (ie that lives in the Page tree)
    """
    # TODO Default managers don't apply properly in all cases, not sure why...
    objects = PublishingUrlNodeManager()
    _default_manager = PublishingUrlNodeManager()

    # TODO Must re-implement property here, not sure why...
    @property
    def is_draft(self):
        return self.publishing_is_draft

    # TODO Must re-implement property here, not sure why...
    @property
    def is_published(self):
        return not self.publishing_is_draft

    # borrowed from FluentFieldsMixin. TODO: send upstream
    def placeholders(self):
        # return a dict of placeholders, organised by slot, for access in
        # templates use `page.placeholders.<slot_name>.get_content_items` to
        # test if a placeholder has any items.
        return dict([(p.slot, p)
                     for p in self.placeholder_set.all().select_related()])


    class Meta:
        abstract = True


class PublishableFluentContents(FluentFieldsMixin, PublishingModel):

    class Meta:
        abstract = True


@receiver(publishing_signals.publishing_publish_save_draft)
@receiver(publishing_signals.publishing_unpublish_save_draft)
def save_draft_on_publish_and_unpublish(sender, instance, **kwargs):
    """
    Save draft instance to associate it with, or disassociate it from, its
    published copy.

    Disconnect these signal handlers and reconnect with custom versions if you
    need more control over object saving in downstream projects, such as for
    saving version information with 'reversion'.
    """
    instance.save()


@receiver(models.signals.pre_save)
def publishing_set_update_time(sender, instance, **kwargs):
    """ Update the time modified before saving a publishable object. """
    if hasattr(instance, 'publishing_linked'):
        # Hack to avoid updating `publishing_modified_at` field when a draft
        # publishable item is saved as part of a `publish` operation. This
        # ensures that the `publishing_published_at` timestamp is later than
        # the `publishing_modified_at` timestamp when we publish, which is
        # vital for us to correctly detect whether a draft is "dirty".
        if getattr(instance, '_skip_update_publishing_modified_at', False):
            # Reset flag, in case instance is re-used (e.g. in tests)
            instance._skip_update_publishing_modified_at = False
            return
        instance.publishing_modified_at = timezone.now()


@receiver(models.signals.m2m_changed)
def handle_publishable_m2m_changed(
        sender, instance, action, reverse, model, pk_set, **kwargs):
    """
    Cache related published objects in `pre_clear` so they can be restored in
    `post_clear`.
    """
    # Do nothing if the target model is not publishable.
    if not issubclass(model, PublishingModel):
        return
    # Get the right `ManyRelatedManager`. Iterate M2Ms and compare `sender`
    # (the through model), in case there are multiple M2Ms to the same model.
    if reverse:
        for rel_obj in instance._meta.get_all_related_many_to_many_objects():
            if rel_obj.field.rel.through == sender:
                m2m = getattr(instance, rel_obj.get_accessor_name())
                break
    else:
        for field in instance._meta.many_to_many:
            if field.rel.through == sender:
                m2m = getattr(instance, field.attname)
                break
    # Cache published PKs on the instance.
    if action == 'pre_clear':
        instance._published_m2m_cache = set(
            m2m.filter(publishing_is_draft=False).values_list('pk', flat=True))
    # Add published PKs from the cache.
    if action == 'post_clear':
        m2m.add(*instance._published_m2m_cache)
        del instance._published_m2m_cache


@receiver(publishing_signals.publishing_post_publish)
def update_fluent_cached_urls_post_publish(sender, instance, **kwargs):
    """
    Update Fluent cached URLs for the published copy and its descendents
    """
    update_fluent_cached_urls(instance.publishing_linked)


@receiver(models.signals.post_save)
def sync_mptt_tree_fields_from_draft_to_published_post_save(
        sender, instance, **kwargs):
    """
    Post save trigger to immediately sync MPTT tree structure field changes
    made to draft copies to their corresponding published copy.
    """
    mptt_opts = getattr(instance, '_mptt_meta', None)
    published_copy = getattr(instance, 'publishing_linked', None)
    if mptt_opts and published_copy:
        sync_mptt_tree_fields_from_draft_to_published(instance)


def sync_mptt_tree_fields_from_draft_to_published(
        draft_copy, dry_run=False, force_update_cached_urls=False):
    """
    Sync tree structure changes from a draft publishable object to its
    published copy, and updates the published copy's Fluent cached URLs when
    necessary. Or simulates doing this if ``dry_run`` is ``True``.

    Syncs both actual structural changes (i.e. different parent) and MPTT's
    fields which are a cached representation (and may or may not be correct).
    """
    mptt_opts = getattr(draft_copy, '_mptt_meta', None)
    published_copy = getattr(draft_copy, 'publishing_linked', None)
    if not mptt_opts or not published_copy:
        return {}
    # Identify changed values and prepare dict of changes to apply to DB
    parent_changed = draft_copy.parent != published_copy.parent
    update_kwargs = {
        mptt_opts.parent_attr: draft_copy._mpttfield('parent'),
        mptt_opts.tree_id_attr: draft_copy._mpttfield('tree_id'),
        mptt_opts.left_attr: draft_copy._mpttfield('left'),
        mptt_opts.right_attr: draft_copy._mpttfield('right'),
        mptt_opts.level_attr: draft_copy._mpttfield('level'),
    }
    # Strip out DB update entries for unchanged or invalid tree fields
    update_kwargs = dict(
        (field, value) for field, value in update_kwargs.items()
        if getattr(draft_copy, field) != getattr(published_copy, field)
        # Only parent may be None, never set tree_id/left/right/level to None
        and not (field != 'parent' and value is None)
    )

    change_report = []
    for field, new_value in update_kwargs.items():
        old_value = getattr(published_copy, field)
        change_report.append((draft_copy, field, old_value, new_value))

    # Forcibly update MPTT field values via UPDATE commands instead of normal
    # model attr changes, which MPTT ignores when you `save`
    if update_kwargs and not dry_run:
        type(published_copy).objects.filter(pk=published_copy.pk).update(
            **update_kwargs)

    # If real tree structure (not just MPTT fields) has changed we must
    # regenerate the cached URLs for published copy translations.
    if parent_changed or force_update_cached_urls:
        # Make our local published obj aware of DB change made by `update`
        published_copy.parent = draft_copy.parent
        # Regenerate the cached URLs for published copy translations.
        change_report += \
            update_fluent_cached_urls(published_copy, dry_run=dry_run)

    return change_report


def update_fluent_cached_urls(item, dry_run=False):
    """
    Regenerate the cached URLs for an item's translations. This is a fiddly
    business: we use "hidden" methods instead of the public ones to avoid
    unnecessary and unwanted slug changes to ensure uniqueness, the logic for
    which doesn't work with our publishing.
    """
    change_report = []
    if hasattr(item, 'translations'):
        for translation in item.translations.all():
            old_url = translation._cached_url
            item._update_cached_url(translation)
            change_report.append(
                (translation, '_cached_url', old_url, translation._cached_url))
            if not dry_run:
                translation.save()
        if not dry_run:
            item._expire_url_caches()
        # Also process all the item's children, in case changes to this item
        # affect the URL that should be cached for the children. We process
        # only draft-or-published children, according to the item's status.
        if item.is_draft:
            children = [child for child in item.children.all()
                        if child.is_draft]
        else:
            children = [child for child in item.get_draft().children.all()
                        if child.is_published]
        for child in children:
            update_fluent_cached_urls(child, dry_run=dry_run)

    return change_report


@receiver(models.signals.pre_delete)
def delete_published_copy_when_draft_deleted(sender, **kwargs):
    # Skip missing or unpublishable instances
    instance = kwargs.get('instance', None)
    if not instance or not hasattr(instance, 'publishing_linked'):
        return

    # If the draft record is deleted, the published object should be as well
    # NOTE: Logic here varies slightly from original to guard for DoesNotExist
    if instance.publishing_is_draft:
        try:
            instance.publishing_linked.delete()
        except (ObjectDoesNotExist, AttributeError):
            pass


@receiver(models.signals.post_migrate)
def create_can_publish_and_can_republish_permissions(sender, **kwargs):
    """
    Add `can_publish` and `can_republish` permissions for each publishable
    model in the system.
    """
    for model in sender.get_models():
        if not issubclass(model, PublishingModel):
            continue
        content_type = ContentType.objects.get_for_model(model)
        permission, created = Permission.objects.get_or_create(
            content_type=content_type, codename='can_publish',
            defaults=dict(name='Can Publish %s' % model.__name__))
        permission, created = Permission.objects.get_or_create(
            content_type=content_type, codename='can_republish',
            defaults=dict(name='Can Republish %s' % model.__name__))


@receiver(publishing_signals.publishing_post_save_related)
def maybe_automatically_publish_drafts_on_save(sender, instance, **kwargs):
    """
    If automatic publishing is enabled, immediately publish a draft copy after
    it has been saved.
    """
    # Skip processing if auto-publishing is not enabled
    if not is_automatic_publishing_enabled(sender):
        return
    # Skip missing or unpublishable instances
    if not instance or not hasattr(instance, 'publishing_linked'):
        return
    # Ignore saves of published copies
    if instance.is_published:
        return
    # Ignore saves of already-published draft copies
    if not instance.is_dirty:
        return
    # Immediately publish saved draft copy
    instance.publish()
