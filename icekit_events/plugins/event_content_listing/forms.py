from icekit.plugins.content_listing.forms import ContentListingAdminForm

from icekit_events.models import EventBase

from .models import EventContentListingItem


class EventContentListingAdminForm(ContentListingAdminForm):

    class Meta:
        model = EventContentListingItem
        fields = '__all__'

    def filter_content_types(self, content_type_qs):
        """ Filter the content types selectable to only event subclasses """
        valid_ct_ids = []
        for ct in content_type_qs:
            model = ct.model_class()
            if model and issubclass(model, EventBase):
                valid_ct_ids.append(ct.id)
        return content_type_qs.filter(pk__in=valid_ct_ids)
