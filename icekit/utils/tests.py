import os
import shutil

from django.conf import settings
from django_dynamic_fixture import G
from django_webtest import WebTest

from . import testing
from icekit.tests.models import ImageTest


class TestingUtils(WebTest):
    def test_test_image_create_and_delete(self):
        # Create the image model object.
        image_test = G(ImageTest)

        # Save the image field with the test image function to create an actual image file.
        image_test.image.save(*testing.new_test_image())

        # Check that the file was created as intended.
        image_path = image_test.image.path
        self.assertTrue(os.path.exists(image_path))

        # Generate a fake thumbnail style file to test cleanup.
        dest_dir = os.path.join(settings.BASE_DIR, 'public', 'media', 'thumbs')
        if not os.path.exists(dest_dir):
            os.makedirs(dest_dir)
        shutil.copy(image_path, dest_dir)
        dst_file = '%s/%s' % (dest_dir, image_test.image.name.split('/')[1])
        dst_thumb_file = '%s.1800x1800_q85.png' % dst_file
        os.rename(dst_file, dst_thumb_file)
        self.assertTrue(os.path.exists(dst_thumb_file))

        # Ensure that the delete function removes the image
        testing.delete_test_image(image_test.image)
        self.assertFalse(os.path.exists(image_path))

        # Ensure that the delete function remove the thumbnail style images.
        self.assertFalse(os.path.exists(dst_thumb_file))
