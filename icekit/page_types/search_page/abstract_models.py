from django.db import models

from fluent_pages.integration.fluent_contents import FluentContentsPage
from icekit.mixins import ListableMixin

from icekit.models import ICEkitFluentContentsPageMixin


class AbstractUnpublishableSearchPage(FluentContentsPage, ListableMixin):
    class Meta:
        abstract = True
        verbose_name = 'Search page'


class AbstractSearchPage(ICEkitFluentContentsPageMixin, ListableMixin):
    default_search_type = models.CharField(max_length=255, blank=True, help_text="Default to a top-level result type, e.g 'Education'. This value must be one of the top-level facets.")

    class Meta:
        abstract = True
        verbose_name = 'Search page'

    def get_type(self):
        # we don't normally want pages to say they're a 'page'
        return ""

    def get_type_plural(self):
        return ""

    def get_parent(self):
        if self.parent:
            return self.parent.get_visible()
        return None