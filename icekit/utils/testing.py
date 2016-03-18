import contextlib
import glob
import os
import uuid
import warnings

from django.conf import settings
from django.core.files.base import ContentFile
from nose.tools import nottest
from PIL import Image, ImageDraw
from six import BytesIO


@nottest
@contextlib.contextmanager
def get_test_image(storage):
    """
    Context manager that creates an image with the given storage class, returns
    a storage name, and cleans up (including thumbnails) when done.

    Example:

        with get_test_image(obj.image_field.storage) as name:
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


# DEPRECATED ##################################################################


@nottest
def new_test_image():
    """
    Creates an automatically generated test image.
    In your testing `tearDown` method make sure to delete the test
    image with the helper function `delete_test_image`.
    The recommended way of using this helper function is as follows:
        object_1.image_property.save(*new_test_image())
    :return: Image name and image content file.
    """
    warnings.warn(DeprecationWarning(
        "new_test_image() is deprecated in favour of the get_sample_image() "
        "context manager."), stacklevel=2)
    image_name = 'test-{}.png'.format(uuid.uuid4())
    image = Image.new('RGBA', size=(50, 50), color=(256, 0, 0))
    ImageDraw.Draw(image)
    byte_io = BytesIO()
    image.save(byte_io, 'png')
    byte_io.seek(0)
    return image_name, ContentFile(byte_io.read(), image_name)


@nottest
def delete_test_image(image_field):
    """
    Deletes test image generated as well as thumbnails if created.
    The recommended way of using this helper function is as follows:
        delete_test_image(object_1.image_property)
    :param image_field: The image field on an object.
    :return: None.
    """
    warnings.warn(DeprecationWarning(
        "delete_test_image() is deprecated in favour of the "
        "get_sample_image() context manager."), stacklevel=2)
    # ensure all thumbs are deleted
    for filename in glob.glob(
        os.path.join(
            settings.BASE_DIR, 'public', 'media', 'thumbs', image_field.name.split('/')[-1]
        ) + '*'
    ):
        os.unlink(filename)
    # delete the saved file
    image_field.delete()
