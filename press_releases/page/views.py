from django.http import Http404
from django.template.response import TemplateResponse
from fluent_pages.models import UrlNode
from press_releases.models import PressRelease

def detail(request, slug):
    """
    A press release detail page view.
    """
    try:
        # Add '$' slug suffix to match published press release copies
        press_release = PressRelease.objects.visible().get(
            slug__in=[slug, slug + '$'])
    except PressRelease.DoesNotExist:
        raise Http404

    context = {
        'page': press_release,
        'title': press_release.title
    }
    return TemplateResponse(
        request, press_release.get_layout_template_name(), context)
