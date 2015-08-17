from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.abstract_models import FluentFieldsMixin


class AbstractLayoutPage(FluentContentsPage, FluentFieldsMixin):
    class Meta:
        abstract = True
        verbose_name = 'Layout Page'
