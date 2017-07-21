from django.template import RequestContext
from django.template.response import TemplateResponse

from icekit.publishing.utils import get_visible_object_or_404

from .models import Location


def index(request):
    locations = Location.objects.visible()
    context = RequestContext(request, {
        'locations': locations,
    })
    template = 'icekit/plugins/location/index.html'
    return TemplateResponse(request, template, context)


def location(request, slug):
    location = get_visible_object_or_404(Location, slug=slug)
    context = RequestContext(request, {
        'location': location,
    })
    template = 'icekit/plugins/location/location.html'
    return TemplateResponse(request, template, context)
