"""
Views for ``icekit_events`` app.
"""

# Do not use generic class based views unless there is a really good reason to.
# Functional views are much easier to comprehend and maintain.
import warnings

from django.core.exceptions import PermissionDenied
from django.http import Http404
from django.shortcuts import get_object_or_404
from django.template import RequestContext
from django.template.response import TemplateResponse

from . import models
from .utils import permissions


def index(request, is_preview=False):
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

    # If this is a preview make sure the user has appropriate permissions.
    if is_preview and not permissions.allowed_to_preview(request.user):
        raise PermissionDenied

    occurrences = models.Occurrence.objects.visible()
    context = {
        'is_preview': is_preview,
        'occurrences': occurrences,
    }
    return TemplateResponse(request, 'icekit_events/index.html', context)


def event(request, slug, is_preview=False):
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

    if is_preview and not permissions.allowed_to_preview(request.user):
        raise PermissionDenied

    event = get_object_or_404(models.EventBase.objects.visible(), slug=slug)
    if not event:
        raise Http404

    context = RequestContext(request, {
        'is_preview': is_preview,
        'event': event,
    })
    # TODO Not sure where the `Event.template` notion comes from, keeping it
    # here for now for backwards compatibility
    template = getattr(event, 'template',  'icekit_events/event.html')
    return TemplateResponse(request, template, context)


def occurrence(request, event_id, occurrence_id, is_preview=False):
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

    if is_preview and not permissions.allowed_to_preview(request.user):
        raise PermissionDenied

    try:
        occurrence = models.Occurrence.objects \
            .filter(event_id=event_id, id=occurrence_id) \
            .visible()[0]
    except IndexError:
        raise Http404

    context = {
        'is_preview': is_preview,
        'occurrence': occurrence,
    }
    return TemplateResponse(
        request,   'icekit_events/occurrence.html', context)
