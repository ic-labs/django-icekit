from django.http import Http404
from django.shortcuts import get_object_or_404
from django.template import RequestContext
from django.template.response import TemplateResponse

from . import models

def work(request, slug):
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

    item = get_object_or_404(models.WorkBase.objects.visible(), slug=slug)
    if not item:
        raise Http404

    context = RequestContext(request, {
        'page': item,
        'work': item,
    })

    template = 'gk_collections/work.html'
    return TemplateResponse(request, template, context)

def creator(request, slug):
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

    item = get_object_or_404(models.CreatorBase.objects.visible(), slug=slug)
    if not item:
        raise Http404

    context = RequestContext(request, {
        'page': item,
        'creator': item,
    })

    template = 'gk_collections/creator.html'
    return TemplateResponse(request, template, context)
