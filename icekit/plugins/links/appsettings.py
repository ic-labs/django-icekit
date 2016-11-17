from django.conf import settings

ICEKIT = getattr(settings, 'ICEKIT', {})

RELATION_STYLE_CHOICES = ICEKIT.get('RELATION_STYLE_CHOICES', (("", "Normal"), ))