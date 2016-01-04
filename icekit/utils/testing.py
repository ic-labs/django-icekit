# USEFUL FUNCTIONS DESIGNED FOR TESTS ##############################################################
import glob
import os
import uuid

from django.conf import settings
from django.core.files.base import ContentFile
from PIL import Image, ImageDraw
from six import BytesIO


def new_test_image():
    """
    Creates an automatically generated test image.

    In your testing `tearDown` method make sure to delete the test
    image with the helper function `delete_test_image`.

    The recommended way of using this helper function is as follows:

        object_1.image_property.save(*new_test_image())

    :return: Image name and image content file.
    """
    image_name = 'test-{}.png'.format(uuid.uuid4())
    image = Image.new('RGBA', size=(50, 50), color=(256, 0, 0))
    ImageDraw.Draw(image)
    byte_io = BytesIO()
    image.save(byte_io, 'png')
    byte_io.seek(0)

    return image_name, ContentFile(byte_io.read(), image_name)


def delete_test_image(image_field):
    """
    Deletes test image generated as well as thumbnails if created.

    The recommended way of using this helper function is as follows:

        delete_test_image(object_1.image_property)

    :param image_field: The image field on an object.
    :return: None.
    """
    # ensure all thumbs are deleted
    for filename in glob.glob(
        os.path.join(
            settings.BASE_DIR, 'public', 'media', 'thumbs', image_field.name.split('/')[-1]
        ) + '*'
    ):
        os.unlink(filename)
    # delete the saved file
    image_field.delete()
