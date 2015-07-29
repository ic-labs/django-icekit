from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.models import FluentFieldsMixin


class LayoutPage(FluentContentsPage, FluentFieldsMixin):
    class Meta:
        verbose_name = 'Layout Page'
