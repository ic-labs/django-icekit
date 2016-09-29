from icekit_events.models import AbstractEventListingPage


class EventListingPage(AbstractEventListingPage):

    def get_response(self, request, parent, *args, **kwargs):
        import ipdb; ipdb.set_trace()  # XXX BREAKPOINT
