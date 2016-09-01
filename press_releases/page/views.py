from django.http import Http404
from django.template.response import TemplateResponse
from ..models import PressRelease

def detail(request, slug):
    """
    Detail page view.
    """
    try:
        press_release = PressRelease.objects.visible().get(
            slug=slug)
    except PressRelease.DoesNotExist:
        raise Http404

    context = {
        'page': press_release,
        'title': press_release.title
    }
    return TemplateResponse(
        request, press_release.get_layout_template_name(), context)
