# Configuration options for ``iiif`` app, refer to docs/topics/iiif.rst
from django.conf import settings


try:
    IIIF_STORAGE = settings.IIIF_STORAGE
except AttributeError:
    IIIF_STORAGE = settings.DEFAULT_FILE_STORAGE
