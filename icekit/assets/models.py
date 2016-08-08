from __future__ import unicode_literals

import six
from django.db import models
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem
from polymorphic import PolymorphicModel


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

    def get_uses(self):
        return [item.parent.get_absolute_url() for item in self.assetitem_set().all()]

    def __str__(self):
        return self.title


class AssetItem(ContentItem):
    """
    Concrete uses of an Asset.
    """
    asset = models.ForeignKey(
        'icekit.assets.models.Asset',
    )

    class Meta:
        abstract = True
        verbose_name = _('Asset Item')
        verbose_name_plural = _('Asset Items')

    def __str__(self):
        return six.text_type(self.asset)
