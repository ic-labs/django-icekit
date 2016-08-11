from django.utils.translation import ugettext_lazy as _

from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.abstract_models import LayoutFieldMixin
from icekit.publishing.models import PublishableFluentContentsPage


class AbstractUnpublishableArticlePage(FluentContentsPage, LayoutFieldMixin):
    class Meta:
        abstract = True
        permissions = (
            ('change_page_layout', _("Can change Page layout")),
        )
        verbose_name = 'Article Page'
        # Simplify & shorten "pagetype_icekit_page_types_article_articlepage"
        db_table = 'pagetype_icekit_article_articlepage'


# TODO Not DRY; try extending AbstractUnpublishableArticlePage?
class AbstractArticlePage(PublishableFluentContentsPage, LayoutFieldMixin):
    class Meta:
        abstract = True
        permissions = (
            ('change_page_layout', _("Can change Page layout")),
        )
        verbose_name = 'Article Page'
        # Simplify & shorten "pagetype_icekit_page_types_article_articlepage"
        db_table = 'pagetype_icekit_article_articlepage'
