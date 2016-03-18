import os
import shutil

from django.conf import settings
from django_dynamic_fixture import G
from django_webtest import WebTest

from icekit.utils.testing import get_sample_image
from icekit.tests.models import ImageTest


class TestingUtils(WebTest):
    def test_get_sample_image(self):
        image_test = G(ImageTest)

        with get_sample_image(image_test.image.storage) as image_name:
            # Check that the image was created.
            image_test.image = image_name
            self.assertTrue(os.path.exists(image_test.image.path))

            # Generate a fake thumbnail to test cleanup.
            THUMBNAIL_ROOT = os.path.join(
                settings.MEDIA_ROOT,
                settings.THUMBNAIL_BASEDIR,
            )
            if not os.path.exists(THUMBNAIL_ROOT):
                os.makedirs(THUMBNAIL_ROOT)
            thumbnail = os.path.join(
                THUMBNAIL_ROOT,
                '%s.1800x1800_q85.png' % image_name,
            )
            shutil.copy(image_test.image.path, thumbnail)
            self.assertTrue(os.path.exists(thumbnail))

        # Check that the image and thumbnails are deleted.
        self.assertFalse(os.path.exists(image_test.image.path))
        self.assertFalse(os.path.exists(thumbnail))
