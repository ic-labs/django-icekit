from django.conf import settings


def environment(request):
    """
    Add ``COMPRESS_ENABLED`` to the context.
    """
    context = {
        'COMPRESS_ENABLED': settings.COMPRESS_ENABLED,
    }
    return context
