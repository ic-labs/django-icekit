from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.models import ICEkitFluentContentsPageMixin


class AbstractUnpublishableSearchPage(FluentContentsPage):
    class Meta:
        abstract = True
        verbose_name = 'Search page'


class AbstractSearchPage(ICEkitFluentContentsPageMixin):
    class Meta:
        abstract = True
        verbose_name = 'Search page'
