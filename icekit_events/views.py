"""
Views for ``icekit_events`` app.
"""

# Do not use generic class based views unless there is a really good reason to.
# Functional views are much easier to comprehend and maintain.
import warnings

from django.core.exceptions import PermissionDenied
from django.db.models import Q
from django.http import Http404
from django.shortcuts import get_object_or_404
from django.template import RequestContext
from django.template.response import TemplateResponse

from . import models
from .utils import permissions


def index(request):
    """
    Listing page for event `Occurrence`s.

    :param request: Django request object.
    :param is_preview: Should the listing page be generated as a preview? This
                       will allow preview specific actions to be done in the
                       template such as turning off tracking options or adding
                       links to the admin.
    :return: TemplateResponse
    """
    warnings.warn(
        "icekit_events.views.index is deprecated and will disappear in a "
        "future version. If you need this code, copy it into your project."
        , DeprecationWarning
    )

    occurrences = models.Occurrence.objects.visible()
    context = {
        'occurrences': occurrences,
    }
    return TemplateResponse(request, 'icekit_events/index.html', context)


def event(request, slug):
    """
    :param request: Django request object.
    :param event_id: The `id` associated with the event.
    :param is_preview: Should the listing page be generated as a preview? This
                       will allow preview specific actions to be done in the
                       template such as turning off tracking options or adding
                       links to the admin.
    :return: TemplateResponse
    """
    # If this is a preview make sure the user has appropriate permissions.

    event = get_object_or_404(models.EventBase.objects.visible(), slug=slug)

    context = RequestContext(request, {
        'event': event,
        'page': event,
    })
    # TODO Not sure where the `Event.template` notion comes from, keeping it
    # here for now for backwards compatibility
    template = getattr(event, 'template',  'icekit_events/event.html')
    return TemplateResponse(request, template, context)


def event_type(request, slug):
    type = get_object_or_404(models.EventType.objects.all(), slug=slug)
    occurrences = models.Occurrence.objects.filter(Q(event__primary_type=type) | Q(event__secondary_types=type)).upcoming().visible()

    context = RequestContext(request, {
        'type': type,
        'occurrences': occurrences,
        'page': type,
    })

    return TemplateResponse(request, "icekit_events/type.html", context
                            )


def occurrence(request, event_id, occurrence_id):
    """
    :param request: Django request object.
    :param event_id: The `id` associated with the occurrence's event.
    :param occurrence_id: The `id` associated with the occurrence.
    :param is_preview: Should the listing page be generated as a preview? This
                       will allow preview specific actions to be done in the
                       template such as turning off tracking options or adding
                       links to the admin.
    :return: TemplateResponse
    """
    # If this is a preview make sure the user has appropriate permissions.
    warnings.warn(
        "icekit_events.views.occurrence is deprecated and will disappear in a "
        "future version. If you need this code, copy it into your project."
        , DeprecationWarning
    )

    try:
        occurrence = models.Occurrence.objects \
            .filter(event_id=event_id, id=occurrence_id) \
            .visible()[0]
    except IndexError:
        raise Http404

    context = {
        'occurrence': occurrence,
    }
    return TemplateResponse(
        request,   'icekit_events/occurrence.html', context)
