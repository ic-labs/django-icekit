from django.conf import settings


def environment(request=None):
    """
    Return ``COMPRESS_ENABLED``, ``SITE_NAME``, and any settings listed
    in ``ICEKIT_CONTEXT_PROCESSOR_SETTINGS`` as context.
    """
    context = {
        'COMPRESS_ENABLED': settings.COMPRESS_ENABLED,
        'SITE_NAME': settings.SITE_NAME,
    }
    for key in settings.ICEKIT_CONTEXT_PROCESSOR_SETTINGS:
        context[key] = getattr(settings, key, None)
    return context
