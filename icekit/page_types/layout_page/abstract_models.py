from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.abstract_models import LayoutFieldMixin


class AbstractLayoutPage(FluentContentsPage, LayoutFieldMixin):
    class Meta:
        abstract = True
        verbose_name = 'Layout Page'
