import six
from django.db import models
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem
from polymorphic.models import PolymorphicModel

from . import abstract_models, managers


class Layout(abstract_models.AbstractLayout):
    """
    An implementation of ``fluent_pages.models.db.PageLayout`` that uses
    plugins to get template name choices instead of scanning a directory given
    in settings.
    """
    objects = managers.LayoutQuerySet.as_manager()


class MediaCategory(abstract_models.AbstractMediaCategory):
    """
    A categorisation model for Media assets.
    """
    pass


class Asset(PolymorphicModel):
    """
    A static asset available for use on a CMS page.
    """
    title = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('The title is shown in the "title" attribute'),
    )
    caption = models.TextField(
        blank=True,
    )
    categories = models.ManyToManyField(
        'icekit.MediaCategory',
        blank=True,
        related_name='%(app_label)s_%(class)s_related',
    )
    admin_notes = models.TextField(
        blank=True,
        help_text=_('Internal notes for administrators only.'),
    )

    def get_admin_thumbnail(self, width=150, height=150):
        raise NotImplementedError
    get_admin_thumbnail.short_description = "thumbnail"

    def get_child_type(self):
        return self.polymorphic_ctype
    get_child_type.short_description = 'type'

    def get_uses(self):
        return [item.parent.get_absolute_url() for item in self.assetitem_set().all()]

    def __str__(self):
        return self.title
