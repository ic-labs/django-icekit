"""
Views for ``response_pages`` app.
"""

from django import http
from django.template import (RequestContext, loader)
from django.views.decorators.csrf import requires_csrf_token
from django.views import defaults

from . import abstract_models, models


def get_response_page(request, return_type, template_location, response_page_type):
    """
    Helper function to get an appropriate response page if it exists.

    This function is not designed to be used directly as a view. It is
    a helper function which can be called to check if a ResponsePage
    exists for a ResponsePage type (which is also active).

    :param request:
    :param return_type:
    :param template_location:
    :param response_page_type:
    :return:
    """
    try:
        page = models.ResponsePage.objects.get(
            is_active=True,
            type=response_page_type,
        )
        template = loader.get_template(template_location)
        content_type = None

        body = template.render(
            RequestContext(request, {'request_path': request.path, 'page': page, })
        )
        return return_type(body, content_type=content_type)
    except models.ResponsePage.DoesNotExist:
        return None


@requires_csrf_token
def page_not_found(request, template_name='404.html'):
    """
    Custom page not found (404) handler.

    Don't raise a Http404 or anything like that in here otherwise
    you will cause an infinite loop. That would be bad.

    If no ResponsePage exists for with type ``RESPONSE_HTTP404`` then
    the default template render view will be used.

    Templates: :template:`404.html`
    Context:
        request_path
            The path of the requested URL (e.g., '/app/pages/bad_page/')
        page
            A ResponsePage with type ``RESPONSE_HTTP404`` if it exists.
    """
    rendered_page = get_response_page(
        request,
        http.HttpResponseNotFound,
        'icekit/response_pages/404.html',
        abstract_models.RESPONSE_HTTP404
    )
    if rendered_page is None:
        return defaults.page_not_found(request, template_name)
    return rendered_page


@requires_csrf_token
def server_error(request, template_name='500.html'):
    """
    Custom 500 error handler.

    The exception clause is so broad to capture any 500 errors that
    may have been generated from getting the response page e.g. if the
    database was down. If they were not handled they would cause a 500
    themselves and form an infinite loop.

    If no ResponsePage exists for with type ``RESPONSE_HTTP500`` then
    the default template render view will be used.

    Templates: :template:`500.html`
    Context:
        page
            A ResponsePage with type ``RESPONSE_HTTP500`` if it exists.
    """
    try:
        rendered_page = get_response_page(
            request,
            http.HttpResponseServerError,
            'icekit/response_pages/500.html',
            abstract_models.RESPONSE_HTTP500
        )
        if rendered_page is not None:
            return rendered_page
    except Exception:
        pass

    return defaults.server_error(request, template_name)
