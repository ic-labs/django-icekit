from django.utils.translation import ugettext_lazy as _
from fluent_pages.integration.fluent_contents import FluentContentsPage
from icekit.abstract_models import LayoutFieldMixin


class ArticlePage(FluentContentsPage, LayoutFieldMixin):
    """
    An Article Page implementation similar to ``FluentPage``.

    ``FluentPage`` was not abstracted from as the layout options were
    wanted to be separated.

    It is also anticipated that this class will be extended
    significantly in the future.
    """

    class Meta:
        verbose_name = 'Article'
        permissions = (
            ('change_page_layout', _("Can change Page layout")),
        )
