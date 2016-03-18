import contextlib
import glob
import os
import uuid

from django.conf import settings
from PIL import Image, ImageDraw


@contextlib.contextmanager
def get_sample_image(storage):
    """
    Context manager that creates an image with the given storage class, returns
    a storage name, and cleans up (including thumbnails) when done.

    Example:

        with get_sample_image(obj.image_field.storage) as name:
            obj.image_field = name

    """
    # Generate unique name.
    storage_name = 'test-{}.png'.format(uuid.uuid4())

    # Create image.
    image_file = Image.new('RGBA', size=(50, 50), color=(255, 0, 0))
    ImageDraw.Draw(image_file)
    storage_file = storage.open(storage_name, 'wb')
    image_file.save(storage_file, 'png')

    # Yield storage name.
    yield storage_name

    # Delete thumbnails, if they exist.
    if hasattr(settings, 'THUMBNAIL_BASEDIR'):
        THUMBNAIL_ROOT = os.path.join(
            settings.MEDIA_ROOT,
            settings.THUMBNAIL_BASEDIR,
        )
        thumbs = glob.glob(os.path.join(THUMBNAIL_ROOT, storage_name + '*'))
        for filename in thumbs:
            os.unlink(filename)
        # Delete empty thumbnail directories.
        try:
            os.removedirs(THUMBNAIL_ROOT)
        except OSError:
            pass

    # Delete image.
    storage.delete(storage_name)
