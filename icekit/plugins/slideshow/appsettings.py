from django.conf import settings


SLIDE_SHOW_CONTENT_PLUGINS = getattr(
    settings,
    'ICEKIT_SLIDE_SHOWPLUGINS',
    ['ImagePlugin', 'TextPlugin', ]
)
