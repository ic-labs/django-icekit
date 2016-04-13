from copy import deepcopy

from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.core.exceptions import FieldError, ObjectDoesNotExist, \
    MultipleObjectsReturned
from django.db import models
from django.dispatch import receiver
from django.utils import timezone

from fluent_contents.models import Placeholder
from fluent_pages import appsettings
from fluent_pages.models import UrlNode

from .managers import PublishingManager, PublishingUrlNodeManager
from .middleware import get_draft_status
from .utils import PublishingException, assert_draft
from . import signals


def create_can_publish_permission(sender, **kwargs):
    """
    Add `can_publish` permission for each of the publishable model.
    """
    for model in sender.publishable_models:
        content_type = ContentType.objects.get_for_model(model)
        permission, created = Permission.objects.get_or_create(
            content_type=content_type, codename='can_publish',
            defaults=dict(name='Can Publish %s' % model.__name__))


def custom_publishing_pre_delete(sender, **kwargs):
    instance = kwargs.get('instance', None)
    if not instance:
        return

    # If the draft record is deleted, the published object should be as well
    # NOTE: Logic here varies slightly from original to guard for DoesNotExist
    if instance.publishing_is_draft:
        try:
            instance.publishing_linked.delete()
        except (ObjectDoesNotExist, AttributeError):
            pass


@receiver(models.signals.pre_save)
def publishing_set_update_time(sender, instance, **kwargs):
    """ Update the time modified before saving a publishable object. """
    if hasattr(instance, 'publishing_linked'):
        # Hack to avoid updating `publishing_modified_at` field when a draft
        # publishable item is saved as part of a `publish` operation. This
        # ensures that the `publishing_published_at` timestamp is later than
        # the `publishing_modified_at` timestamp when we publish, which is vital
        # for us to correctly detect whether a draft is "dirty".
        if getattr(instance, '_skip_update_publishing_modified_at', False):
            # Reset flag, in case instance is re-used (e.g. in tests)
            instance._skip_update_publishing_modified_at = False
            return
        instance.publishing_modified_at = timezone.now()


class PublishingModel(models.Model):
    """
    Model fields required to track publishing status. They can be added
    directly to models when possible, or monkey-patched into place via the
    `AppConfig` in this module.
    """
    objects = PublishingManager()

    STATE_PUBLISHED = False
    STATE_DRAFT = True

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
        for placeholder_field in self.get_placeholder_fields():
            placeholder = getattr(self, placeholder_field)
            for plugin in placeholder.get_plugins_list():
                if plugin.changed_date \
                        > self.publishing_linked.publishing_modified_at:
                    return True

        return False

    @property
    def is_draft(self):
        return self.publishing_is_draft == self.STATE_DRAFT

    @property
    def is_published(self):
        return self.publishing_is_draft == self.STATE_PUBLISHED

    @property
    def is_visible(self):
        """
        Return True if the item is the visible according to the request
        context:
        - for privileged users: is a draft item
        - for everyone else: is a published item
        """
        if not get_draft_status():
            return self.is_published
        else:
            return self.is_draft

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
            return self.publishing_linked is not None
        raise ValueError(
            "Publishable object %r is neither draft nor published" % self)

    def get_draft(self):
        """
        Return self if this object is a draft, otherwise return the draft
        copy of a published item.
        """
        if self.is_draft:
            return self
        elif self.is_published:
            return self.publishing_draft
        raise ValueError(
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
        raise ValueError(
            "Publishable object %r is neither draft nor published" % self)

    def get_visible(self):
        """
        Return the visible version of publishable items, which means:
        - for privileged users: a draft items, whether published or not
        - for everyone else: the published copy of items.
        """
        if get_draft_status():
            return self.get_draft()
        else:
            return self.get_published()

    def get_unique_together(self):
        return self._meta.unique_together

    def get_field(self, field_name):
        # return the actual field (not the db representation of the field)
        try:
            return self._meta.get_field_by_name(field_name)[0]
        except models.fields.FieldDoesNotExist:
            return None

    def get_placeholder_fields(self, obj=None):
        placeholder_fields = []

        try:
            from cms.models.placeholdermodel import Placeholder
        except ImportError:
            return placeholder_fields

        if obj is None:
            obj = self

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
        # Make sure that this object is dirty and a draft.
        if self.is_draft and self.is_dirty:
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

            # Set the date the object should be published at.
            publish_obj.publishing_published_at = self.publishing_published_at

            # Perform per-model preparation before saving published copy
            publish_obj.publishing_prepare_published_copy()

            # Save the new published object as a separate instance to self.
            publish_obj.save()
            # Sanity-check that we successfully saved the published copy
            if not publish_obj.pk:
                raise PublishingException("Failed to save published copy")

            # As it is a new object we need to clone each of the
            # translatable fields, placeholders and required relations.
            self.clone_translations(publish_obj)
            self.clone_placeholder(publish_obj)
            self.clone_relations(publish_obj)

            # Extra relationship-cloning smarts
            publish_obj.publishing_clone_relations(self)

            # Link the published object to the draft object.
            self.publishing_linked = publish_obj

            # Flag draft instance when it is being updated as part of a
            # publish action, for use in `publishing_set_update_time`
            self._skip_update_publishing_modified_at = True

            # Signal the pre-save hook for publication, save then signal
            # the post publish hook.
            signals.publishing_publish_pre_save_draft.send(
                sender=type(self), instance=self)

            # Save the change and create a revision to mark the change.
            self.publishing_save_draft_after_publish()

            signals.publishing_post_publish.send(
                sender=type(self), instance=self)
            return publish_obj

    @assert_draft
    def unpublish(self):
        """
        Un-publish the current object.
        """
        if self.is_draft and self.publishing_linked:
            signals.publishing_pre_unpublish.send(
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
            self.save()
            signals.publishing_post_unpublish.send(
                sender=type(self), instance=self)

    @assert_draft
    def revert_to_public(self):
        """
        Revert draft instance to the last published instance.
        """
        raise Exception(
            "TODO: Re-implement revert-to-public without reversion")

    def publishing_save_draft_after_publish(self):
        """
        Save draft object after it has been published. We do this in this
        method to make it easier to override the save to do things like
        create a revision when an item is published.
        """
        self.save()

    def publishing_prepare_published_copy(self):
        """ Prepare published copy of draft prior to saving it """
        pass

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
                if getattr(rel_obj, 'publishing_is_draft', True):
                    dst.add(rel_obj)
                    # If the related object also has a published copy, we
                    # need to make sure the published copy also knows about
                    # this newly-published draft. We defer this until below
                    # when we are no longer iterating over the queryset
                    # we need to modify.
                    try:
                        if rel_obj.publishing_linked:
                            published_rel_obj_copies_to_add.append(
                                rel_obj.publishing_linked)
                    except AttributeError:
                        pass  # No `publishing_linked` attr to handle
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
        for field in src_obj._meta.many_to_many:
            src = getattr(src_obj, field.name)
            dst = getattr(self, field.name)
            clone(src, dst)
            seen_rel_through_tables.add(field.rel.through)
        # Reverse.
        for field in \
                src_obj._meta.get_all_related_many_to_many_objects():
            # Skip reverse relationship if we have already seen, see note
            # about `seen_rel_through_tables` above.
            if field.field.rel.through in seen_rel_through_tables:
                continue
            field_accessor_name = field.get_accessor_name()
            # M2M relationships with `self` don't have accessor names
            if not field_accessor_name:
                continue
            src = getattr(src_obj, field_accessor_name)
            dst = getattr(self, field_accessor_name)
            clone(src, dst)

    @assert_draft
    def patch_placeholders(self):
        published_obj = self.publishing_linked

        for draft_placeholder, published_placeholder in zip(
                Placeholder.objects.parent(self),
                Placeholder.objects.parent(published_obj)
        ):
            if draft_placeholder.pk == published_placeholder.pk:
                published_placeholder.pk = None
                published_placeholder.save()

    def clone_translations(self, dst_obj):
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

    def clone_placeholder(self, dst_obj):
        """
        Clone each of the placeholder items.

        :param self: The object which does not get used...
        :param self: The object for which the placeholders are
        to be cloned from.
        :param dst_obj: The object which the cloned placeholders
        are to be related.
        :return: None
        """
        for src_placeholder in Placeholder.objects.parent(self):
            dst_placeholder = Placeholder.objects.create_for_object(
                dst_obj,
                slot=src_placeholder.slot,
                role=src_placeholder.role,
                title=src_placeholder.title
            )

            src_items = src_placeholder.get_content_items()
            src_items.copy_to_placeholder(dst_placeholder)

    def clone_relations(self, dst_obj):
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
        if not hasattr(self, 'contentitem_set'):
            return
        for src_ci, dst_ci in zip(self.contentitem_set.all(),
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


class FluentPublishingModel(PublishingModel):
    objects = PublishingUrlNodeManager()

    class Meta:
        abstract = True

    def _make_slug_unique(self, translation):
        """
        Custom make slug unique checked.
        :param self: The object to which the slug is or will be
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
            if self:
                exclude_kwargs['pk__in'].append(self.pk)

            if self.publishing_linked_id:
                exclude_kwargs['pk__in'].append(self.publishing_linked_id)

            url_nodes = UrlNode.objects.filter(
                parent=self.parent_id,
                translations__slug=translation.slug,
                translations__language_code=translation.language_code
            ).exclude(**exclude_kwargs).non_polymorphic()

            if appsettings.FLUENT_PAGES_FILTER_SITE_ID:
                url_nodes = url_nodes.parent_site(self.parent_site_id)

            if not url_nodes.exists():
                break

            count += 1
            translation.slug = '%s-%d' % (original_slug, count)

    def get_root(self):
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
        if self.publishing_is_draft:
            return root_qs.first().get_draft()
        else:
            return root_qs.first().get_published()

    def get_descendants(self, include_self=False, ignore_publish_status=False):
        """
        Replace `mptt.models.MPTTModel.get_descendants` with a version that
        returns only draft or published copy descendants, as appopriate.
        """
        qs = super(FluentPublishingModel, self).get_descendants(
            include_self=include_self)
        if not ignore_publish_status:
            try:
                qs = qs.filter(publishing_is_draft=self.publishing_is_draft)
            except FieldError:
                pass  # Likely an unpublishable polymorphic parent
        return qs

    def get_ancestors(self, ascending=False, include_self=False,
                      ignore_publish_status=False):
        """
        Replace `mptt.models.MPTTModel.get_ancestors` with a version that
        returns only draft or published copy ancestors, as appopriate.
        """
        qs = self._original_get_ancestors(
            ascending=ascending, include_self=include_self)
        if not ignore_publish_status:
            try:
                qs = qs.filter(publishing_is_draft=self.publishing_is_draft)
            except FieldError:
                pass  # Likely an unpublishable polymorphic parent
        return qs


models.signals.pre_delete.connect(
    custom_publishing_pre_delete, PublishingModel)
models.signals.post_migrate.connect(
    create_can_publish_permission, sender=PublishingModel)
