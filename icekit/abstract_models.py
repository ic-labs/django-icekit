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
from fluent_contents.extensions import ContentPlugin
from fluent_contents.models import ContentItem
from icekit import appsettings

from . import fields, plugins


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


class BoostedTermsMixin(models.Model):
    """
    Mixin for providing a field for terms which will get boosted search
    priority.
    """
    boosted_terms = models.TextField(
        blank=True,
        default='',  # This is for convenience when adding models in the shell.
        help_text=_(
            'Words (space separated) added here are boosted in relevance for search results '
            'increasing the chance of this appearing higher in the search results.'
        ),
        verbose_name=_('Boosted Search Terms'),
    )

    class Meta:
        abstract = True


class AbstractLinkItem(ContentItem):
    """
    A content type that is a relation to another model.

    Subclasses should define:

        item = models.ForeignKey(to)

    Assuming the 'to' model implements `ListableMixin` then the Item renders as
    a list item.
    """
    style = models.CharField(_("Link style"), max_length=255, choices=appsettings.RELATION_STYLE_CHOICES, blank=True)
    type_override = models.CharField(max_length=255, blank=True)
    title_override = models.CharField(max_length=255, blank=True)
    image_override = models.ImageField(
        blank=True,
        upload_to="icekit/listable/list_image/",
    )

    class Meta:
        abstract = True

    def __unicode__(self):
        return _("Relation to '%s'") % unicode(self.item)

    def get_type(self):
        return self.type_override or self.item.get_type()

    def get_title(self):
        return self.title_override or self.item.get_title()

    def get_list_image(self):
        return self.image_override or self.item.get_list_image()


class LinkPlugin(ContentPlugin):
    category = _('Links')
    raw_id_fields = ('item')
    render_template = 'icekit/plugins/link/default.html'
    fieldsets = (
        (None, {
           'fields': (
               'item',
               'style',
           )
        }),
        ('Overrides', {
           'fields': (
               'type_override',
               'title_override',
               'image_override',
           ),
           'classes': ('collapse', )
        }),
    )