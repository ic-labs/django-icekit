from django.conf import settings


def environment(request):
    """
    Add ``COMPRESS_ENABLED`` to the context.
    """
    context = {
        'COMPRESS_ENABLED': settings.COMPRESS_ENABLED,
        'SITE_NAME': settings.SITE_NAME,
    }
    return context
