from django.conf import settings

ICEKIT = getattr(settings, 'ICEKIT', {})

# Sources for `icekit.plugins.FileSystemLayoutPlugin`.
LAYOUT_TEMPLATES = ICEKIT.get('LAYOUT_TEMPLATES', [])
