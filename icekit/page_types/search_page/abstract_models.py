from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.publishing.models import PublishableFluentContentsPage


class AbstractUnpublishableSearchPage(FluentContentsPage):
    class Meta:
        abstract = True
        verbose_name = 'Search page'


class AbstractSearchPage(PublishableFluentContentsPage):
    class Meta:
        abstract = True
        verbose_name = 'Search page'
