from fluent_pages.integration.fluent_contents import FluentContentsPage
from icekit.mixins import ListableMixin

from icekit.publishing.models import PublishableFluentContentsPage


class AbstractUnpublishableSearchPage(FluentContentsPage, ListableMixin):
    class Meta:
        abstract = True
        verbose_name = 'Search page'


class AbstractSearchPage(PublishableFluentContentsPage, ListableMixin):
    class Meta:
        abstract = True
        verbose_name = 'Search page'
