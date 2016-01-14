"""
Models for ``icekit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.template.loader import get_template
from django.utils import encoding, timezone
from django.utils.translation import ugettext_lazy as _
from fluent_contents.analyzer import get_template_placeholder_data
from fluent_contents.models import \
    ContentItemRelation, Placeholder, PlaceholderRelation

from . import fields, plugins


# MIXINS ######################################################################


class LayoutFieldMixin(models.Model):
    """
    Add ``layout`` field to models that already have ``contentitem_set`` and
    ``placeholder_set`` fields.
    """
    layout = models.ForeignKey(
        'icekit.Layout',
        blank=True,
        null=True,
        related_name='%(app_label)s_%(class)s_related',
    )

    fallback_template = 'icekit/layouts/fallback_default.html'

    class Meta:
        abstract = True

    def get_layout_template_name(self):
        """
        Return ``layout.template_name`` or `fallback_template``.
        """
        if self.layout:
            return self.layout.template_name
        return self.fallback_template


class FluentFieldsMixin(LayoutFieldMixin):
    """
    Add ``layout``, ``contentitem_set`` and ``placeholder_set`` fields so we
    can add modular content with ``django-fluent-contents``.
    """
    contentitem_set = ContentItemRelation()
    placeholder_set = PlaceholderRelation()

    class Meta:
        abstract = True

    # HACK: This is needed to work-around a `django-fluent-contents` issue
    # where it cannot handle placeholders being added to a template after an
    # object already has placeholder data in the database.
    # See: https://github.com/edoburu/django-fluent-contents/pull/63
    def add_missing_placeholders(self):
        """
        Add missing placeholders from templates. Return `True` if any missing
        placeholders were created.
        """
        content_type = ContentType.objects.get_for_model(self)
        result = False
        if self.layout:
            for data in self.layout.get_placeholder_data():
                placeholder, created = Placeholder.objects.update_or_create(
                    parent_type=content_type,
                    parent_id=self.pk,
                    slot=data.slot,
                    defaults=dict(
                        role=data.role,
                        title=data.title,
                    ))
                result = result or created
        return result

# MODELS ######################################################################


class AbstractBaseModel(models.Model):
    """
    Abstract base model.
    """

    created = models.DateTimeField(
        default=timezone.now, db_index=True, editable=False)
    modified = models.DateTimeField(
        default=timezone.now, db_index=True, editable=False)

    class Meta:
        abstract = True
        get_latest_by = 'pk'
        ordering = ('-id', )

    def save(self, *args, **kwargs):
        """
        Update ``self.modified``.
        """
        self.modified = timezone.now()
        super(AbstractBaseModel, self).save(*args, **kwargs)


@encoding.python_2_unicode_compatible
class AbstractLayout(AbstractBaseModel):
    """
    An implementation of ``fluent_pages.models.db.PageLayout`` that uses
    plugins to get template name choices instead of scanning a directory given
    in settings.
    """
    title = models.CharField(_('title'), max_length=255)
    template_name = fields.TemplateNameField(
        _('template'),
        plugin_class=plugins.TemplateNameFieldChoicesPlugin,
        unique=True,
    )
    content_types = models.ManyToManyField(
        ContentType,
        help_text='Types of content for which this layout will be allowed.',
    )

    class Meta:
        abstract = True
        ordering = ('title',)

    def __str__(self):
        return self.title

    @classmethod
    def auto_add(cls, template_name, *models, **kwargs):
        """
        Get or create a layout for the given template and add content types for
        the given models to it. Append the verbose name of each model to the
        title with the given ``separator`` keyword argument.
        """
        separator = kwargs.get('separator', ', ')
        content_types = ContentType.objects.get_for_models(*models).values()
        try:
            # Get.
            layout = cls.objects.get(template_name=template_name)
        except cls.DoesNotExist:
            # Create.
            title = separator.join(sorted(
                ct.model_class()._meta.verbose_name for ct in content_types))
            layout = cls.objects.create(
                template_name=template_name,
                title=title,
            )
            layout.content_types.add(*content_types)
        else:
            title = [layout.title]
            # Update.
            for ct in content_types:
                if not layout.content_types.filter(pk=ct.pk).exists():
                    title.append(ct.model_class()._meta.verbose_name)
            layout.title = separator.join(sorted(title))
            layout.save()
            layout.content_types.add(*content_types)
        return layout

    def get_placeholder_data(self):
        """
        Return placeholder data for this layout's template.
        """
        return get_template_placeholder_data(self.get_template())

    def get_template(self):
        """
        Return the template to render this layout.
        """
        return get_template(self.template_name)


@encoding.python_2_unicode_compatible
class AbstractMediaCategory(AbstractBaseModel):
    """
    A categorisation model for Media assets.
    """
    name = models.CharField(
        max_length=255,
        unique=True,
    )

    class Meta:
        abstract = True
        verbose_name_plural = 'Media categories'

    def __str__(self):
        return self.name
