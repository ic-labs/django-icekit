from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.models import ICEkitFluentContentsPageMixin
from icekit.mixins import LayoutFieldMixin, HeroMixin, ListableMixin


class AbstractUnpublishableLayoutPage(FluentContentsPage, LayoutFieldMixin):
    class Meta:
        abstract = True


class AbstractLayoutPage(ICEkitFluentContentsPageMixin, LayoutFieldMixin,
                         HeroMixin, ListableMixin):
    class Meta:
        abstract = True

    def get_type(self):
        # we don't normally want pages to say they're a 'page'
        return ""

    def get_type_plural(self):
        return ""

    def get_parent(self):
        if self.parent:
            return self.parent.get_visible()
        return None

    def get_related_items(self):
        items = []

        related_placeholder = self.placeholder_set.filter(title='Related').first()
        if related_placeholder:
            items += list(related_placeholder.contentitems.all())

        if hasattr(self, 'get_auto_related_items'):
            items += list(self.get_auto_related_items())

        return items
