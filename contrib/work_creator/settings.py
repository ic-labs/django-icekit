from django.conf import settings

COLLECTION_MODELS = getattr(settings, 'COLLECTION_MODELS', {})

WORK_THUMBNAIL_OPTIONS = COLLECTION_MODELS.get(
    'artwork_thumbnail_options', {'size': (250, 250)})

# Where to store downloaded NetX images, relative to `MEDIA_ROOT`.
WORK_IMAGE_PATH = COLLECTION_MODELS.get(
    'work_image_path', 'collection_images')
