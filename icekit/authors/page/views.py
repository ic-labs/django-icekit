from django.http import Http404
from django.template.response import TemplateResponse
from ..models import Author


def detail(request, slug):
    """
    Detail view.
    """
    try:
        author = Author.objects.visible().get(slug=slug)
    except Author.DoesNotExist:
        raise Http404

    context = {
        'page': author,
    }

    return TemplateResponse(
        request, "author/detail.html", context)
