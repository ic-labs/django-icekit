"""
Views for ``icekit`` app.
"""

# Do not use generic class based views unless there is a really good reason to.
# Functional views are much easier to comprehend and maintain.

from django.core.urlresolvers import reverse
from django.http import Http404, HttpResponseRedirect
from django.shortcuts import get_object_or_404
from django.template.response import TemplateResponse


def index(request):
    context = {}
    return TemplateResponse(request, 'icekit/index.html', context)
