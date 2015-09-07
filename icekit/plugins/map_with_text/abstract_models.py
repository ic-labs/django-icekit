from django.db import models
from django.utils.safestring import mark_safe
from django.utils.translation import ugettext_lazy as _
from fluent_contents.extensions import PluginHtmlField
from icekit.plugins.map.abstract_models import AbstractMapItem


class AbstractMapWithTextItem(AbstractMapItem):
    text = PluginHtmlField(
        _('text'),
        blank=True
    )
    map_on_right = models.BooleanField(
        verbose_name=_('Map side'),
        choices=(
            (False, 'Map on left'),
            (True, 'Map on right')
        ),
        default=False
    )

    help_me_out_here = 'A map with text on the side (allows the choice of map to be on the ' \
                       'left or right of the text).'

    class Meta:
        abstract = True
        verbose_name = 'Google Map with Text'

    def get_text(self):
        return mark_safe(self.text)
