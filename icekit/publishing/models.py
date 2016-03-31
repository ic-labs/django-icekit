from django.utils import timezone

from django.db import models
from django.utils.translation import ugettext_lazy as _

from .managers import PublisherManager, PublisherQuerySet


class PublisherModelBase(models.Model):
    """
    Model fields required to track publishing status. They can be added
    directly to models when possible, or monkey-patched into place via the
    `AppConfig` in this module.
    """
    STATE_PUBLISHED = False
    STATE_DRAFT = True

    publisher_linked = models.OneToOneField(
        'self',
        related_name='publisher_draft',
        null=True,
        editable=False,
        on_delete=models.SET_NULL)
    publisher_is_draft = models.BooleanField(
        default=True,
        editable=False,
        db_index=True)
    publisher_modified_at = models.DateTimeField(
        default=timezone.now,
        editable=False)
    publisher_published_at = models.DateTimeField(
        null=True, editable=False)

    publisher_fields = (
        'publisher_linked',
        'publisher_is_draft',
        'publisher_modified_at',
        'publisher_draft',
    )
    publisher_ignore_fields = publisher_fields + (
        'pk',
        'id',
        'publisher_linked',
    )
    publisher_publish_empty_fields = (
        'pk',
        'id',
    )

    # Publication start and end date fields from UrlNode
    # TODO Should these be part of generic model base?
    publication_date = models.DateTimeField(
        _('publication date'), null=True, blank=True, db_index=True,
        help_text=_('''When the page should go live.'''))
    publication_end_date = models.DateTimeField(
        _('publication end date'), null=True, blank=True, db_index=True)

    class Meta:
        abstract = True

    @property
    def is_draft(self):
        return self.publisher_is_draft == self.STATE_DRAFT

    @property
    def is_published(self):
        return self.publisher_is_draft == self.STATE_PUBLISHED

    @property
    def is_dirty(self):
        if not self.is_draft:
            return False

        # If the record has not been published assume dirty
        if not self.publisher_linked:
            return True

        if self.publisher_modified_at \
                > self.publisher_linked.publisher_modified_at:
            return True

        # Get all placeholders + their plugins to find their modified date
        for placeholder_field in self.get_placeholder_fields():
            placeholder = getattr(self, placeholder_field)
            for plugin in placeholder.get_plugins_list():
                if plugin.changed_date \
                        > self.publisher_linked.publisher_modified_at:
                    return True

        return False

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
            if field in self.publisher_ignore_fields:
                continue

            try:
                placeholder = getattr(obj, field)
                if isinstance(placeholder, Placeholder):
                    placeholder_fields.append(field)
            except (ObjectDoesNotExist, AttributeError):
                continue

        return placeholder_fields


class PublisherModel(PublisherModelBase):
    objects = models.Manager()
    publisher_manager = \
        PublisherManager.for_queryset_class(PublisherQuerySet)()

    class Meta:
        abstract = True
        permissions = (
            ('can_publish', 'Can publish'),
        )

    def save(self, suppress_modified=False, **kwargs):
        if suppress_modified is False:
            self.update_modified_at()

        super(PublisherModel, self).save(**kwargs)
