from django.conf import settings


# Configuration options for ``response_pages`` app.


RESPONSE_PAGE_CONTENT_PLUGINS = getattr(
    settings,
    'RESPONSE_PAGE_PLUGINS',
    ['ImagePlugin', 'TextPlugin', ]
)
