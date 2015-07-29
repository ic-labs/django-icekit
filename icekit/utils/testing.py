# USEFUL FUNCTIONS DESIGNED FOR TESTS ##############################################################
import glob
import os
import uuid

from PIL import Image

from django.core.files.base import ContentFile
from django.utils import six


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
    image_buf = six.StringIO()
    image = Image.new('RGBA', size=(50, 50), color=(256, 0, 0))
    image.save(image_buf, 'png')
    image_buf.seek(0)

    return image_name, ContentFile(image_buf.read(), image_name)


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
            os.path.join('public', 'media', 'thumbs', image_field.name) + '*'):
        os.unlink(filename)
    # delete the saved file
    image_field.delete()
