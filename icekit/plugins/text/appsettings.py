from django.conf import settings

FLUENT_TEXT_CLEAN_HTML = getattr(settings, "FLUENT_TEXT_CLEAN_HTML", False)
FLUENT_TEXT_SANITIZE_HTML = getattr(settings, "FLUENT_TEXT_SANITIZE_HTML", False)

ICEKIT = getattr(settings, 'ICEKIT', {})

TEXT_STYLE_CHOICES = ICEKIT.get('TEXT_STYLE_CHOICES', (('', 'Normal'),))
