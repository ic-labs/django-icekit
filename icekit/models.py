"""
Models for ``icekit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

import six
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.db.models.query import QuerySet
from django.template.loader import get_template
from django.utils import encoding, timezone
from django.utils.translation import ugettext_lazy as _
# from fluent_contents.models import ContentItemRelation, PlaceholderRelation
from model_utils.managers import PassThroughManager

from icekit import plugins, validators


# FIELDS ######################################################################


class TemplateNameField(
        six.with_metaclass(models.SubfieldBase, models.CharField)):
    """
    A validated template name. If a ``plugin_class`` is given, which should be
    a ``TemplateNameFieldChoicesPlugin`` subclass, choices will be provided by
    any registered plugins.
    """

    default_validators = [validators.template_name]
    description = _('Template name')

    def __init__(self, *args, **kwargs):
        self.plugin_class = kwargs.pop('plugin_class', None)
        if self.plugin_class:
            # Force the admin to recognise that this field has choices, even
            # though we don't know what they are until runtime.
            kwargs.setdefault('choices', [('', '')])
        # Use the max `max_length` by default. Template names can be long.
        kwargs.setdefault('max_length', 255)
        super(TemplateNameField, self).__init__(*args, **kwargs)

    def formfield(self, **kwargs):
        """
        Get choices from plugins, if necessary.
        """
        if self.plugin_class:
            self._choices = self.plugin_class.get_all_choices(field=self)
        return super(TemplateNameField, self).formfield(**kwargs)


# MIXINS ######################################################################


class FluentFieldsMixin(models.Model):
    """
    Add ``layout``, ``contentitem_set`` and ``placeholder_set`` fields so we
    can add modular content with ``django-fluent-contents``.
    """
    layout = models.ForeignKey(
        'icekit.Layout',
        blank=True,
        null=True,
        related_name='%(app_label)s_%(class)s_related',
    )

    # TODO: Already present in FluentContentsPage. Make separate mixin?
    # contentitem_set = ContentItemRelation()
    # placeholder_set = PlaceholderRelation()

    class Meta:
        abstract = True


# QUERYSETS ###################################################################


class LayoutQuerySet(QuerySet):

    def for_model(self, model):
        """
        Return layouts that are allowed for the given model.
        """
        queryset = self.filter(
            content_types=ContentType.objects.get_for_model(model))
        return queryset


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
class Layout(AbstractBaseModel):
    """
    An implementation of ``fluent_pages.models.db.PageLayout`` that uses
    plugins to get template name choices instead of scanning a directory given
    in settings.
    """
    title = models.CharField(_('title'), max_length=255)
    key = models.SlugField(
        _('key'),
        help_text=_('A short name to identify the layout programmatically.'),
    )
    template_name = TemplateNameField(
        plugin_class=plugins.TemplateNameFieldChoicesPlugin,
    )
    content_types = models.ManyToManyField(
        ContentType,
    )

    objects = PassThroughManager.for_queryset_class(LayoutQuerySet)()

    class Meta:
        ordering = ('title',)

    def __str__(self):
        return self.title

    def get_template(self):
        """
        Return the template to render this layout.
        """
        return get_template(self.template_name)


class MediaCategory(AbstractBaseModel):
    """
    A categorisation model for Media assets.
    """
    name = models.CharField(
        max_length=255,
        unique=True,
    )

    class Meta:
        verbose_name_plural = 'Media categories'

    def __str__(self):
        return self.name
