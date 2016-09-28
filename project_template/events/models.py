from icekit.articles.abstract_models import ListingPage

from icekit_events.models import Event


class EventListingPage(ListingPage):

    class Meta:
        verbose_name = "Event Listing"

    def get_items(self):
        return Event.objects.published()

    def get_visible_items(self):
        return Event.objects.visible()
