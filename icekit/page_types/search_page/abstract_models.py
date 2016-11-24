from fluent_pages.integration.fluent_contents import FluentContentsPage
from icekit.mixins import ListableMixin

from icekit.models import ICEkitFluentContentsPageMixin


class AbstractUnpublishableSearchPage(FluentContentsPage, ListableMixin):
    class Meta:
        abstract = True
        verbose_name = 'Search page'


class AbstractSearchPage(ICEkitFluentContentsPageMixin, ListableMixin):
    class Meta:
        abstract = True
        verbose_name = 'Search page'
