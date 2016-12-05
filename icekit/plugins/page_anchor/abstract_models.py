from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractPageAnchorItem(ContentItem):
    anchor_name = models.CharField(max_length=60, help_text="ID to use for this section, e.g. `foo`, without the `#`. Link to it with `#foo`.")

    class Meta:
        abstract = True
        verbose_name = _('Page Anchor')

    def __str__(self):
        return self.anchor_name
