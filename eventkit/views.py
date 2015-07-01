"""
Views for ``eventkit`` app.
"""

# Do not use generic class based views unless there is a really good reason to.
# Functional views are much easier to comprehend and maintain.
from django.core.exceptions import PermissionDenied
from django.shortcuts import get_object_or_404
from django.template.response import TemplateResponse

from . import models
from .utils import permissions


def index(request, is_preview=False):
    """
    Listing page for events.

    :param request: Django request object.
    :param is_preview: Should the listing page be generated as a preview? This will allow preview
    specific actions to be done in the template such as turning off tracking options or adding links
    to the admin.
    :return: TemplateResponse
    """
    # If this is a preview make sure the user has appropriate permissions to view the preview.
    if is_preview and not permissions.allowed_to_preview(request.user):
        raise PermissionDenied

    events = models.Event.objects.all()
    context = {
        'is_preview': is_preview,
        'events': events,
    }
    return TemplateResponse(request, 'eventkit/index.html', context)


def detail(request, event_id, is_preview=False):
    """

    :param request: Django request object.
    :param event_id: The `id` associated with the event.
    :param is_preview: Should the listing page be generated as a preview? This will allow preview
    specific actions to be done in the template such as turning off tracking options or adding links
    to the admin.
    :return: TemplateResponse
    """
    # If this is a preview make sure the user has appropriate permissions to view the preview.
    if is_preview and not permissions.allowed_to_preview(request.user):
        raise PermissionDenied

    event = get_object_or_404(models.Event, id=event_id)
    context = {
        'is_preview': is_preview,
        'event': event,
    }
    return TemplateResponse(request, event.template, context)
