default_app_config = 'icekit.apps.AppConfig'


def is_multilingual_site():
    from django.conf import settings
    return len(getattr(settings, 'LANGUAGES', [])) > 1
