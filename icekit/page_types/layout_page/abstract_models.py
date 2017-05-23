from icekit.models import ICEkitFluentContentsPageMixin
from icekit.mixins import LayoutFieldMixin, HeroMixin, ListableMixin
from icekit.plugins.descriptors import \
    contribute_to_class as contribute_placeholder_descriptor_to_class


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

        related_placeholder = self.slots.related
        if related_placeholder.exists():
            items += list(related_placeholder)

        if hasattr(self, 'get_auto_related_items'):
            items += list(self.get_auto_related_items())

        return items

contribute_placeholder_descriptor_to_class(AbstractLayoutPage, name='slots')
