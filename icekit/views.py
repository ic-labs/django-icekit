"""
Views for ``icekit`` app.
"""

# Do not use generic class based views unless there is a really good reason to.
# Functional views are much easier to comprehend and maintain.

from django.core.urlresolvers import reverse
from django.http import Http404, HttpResponseRedirect
from django.shortcuts import get_object_or_404
from django.template.response import TemplateResponse
from fluent_pages.models import Page
from fluent_pages.views import CmsPageDispatcher

def index(request):
    try:
        # If there is a page with slug 'home', render it, otherwise render a getting started page
        return CmsPageDispatcher.as_view()(request, path='home/')
    except Http404:
        # render the welcome page
        context = {
            'has_pages': Page.objects.count(),
        }
        return TemplateResponse(request, 'fluent_pages/intro_page.html', context)
