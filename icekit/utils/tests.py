import os
import shutil

from django.conf import settings
from django_dynamic_fixture import G
from django_webtest import WebTest

from icekit.utils import testing
from icekit.tests.models import ImageTest
from icekit.utils.sequences import slice_sequences
from icekit.utils.pagination import describe_page_numbers


class TestingUtils(WebTest):
    def test_get_test_image(self):
        image_test = G(ImageTest)

        with testing.get_test_image(image_test.image.storage) as image_name:
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

    def test_test_image_create_and_delete(self):
        # Create the image model object.
        image_test = G(ImageTest)

        # Save the image field with the test image function to create an actual image file.
        image_test.image.save(*testing.new_test_image())

        # Check that the file was created as intended.
        image_path = image_test.image.path
        self.assertTrue(os.path.exists(image_path))

        # Generate a fake thumbnail style file to test cleanup.
        dest_dir = os.path.join(settings.MEDIA_ROOT, 'thumbs')
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

        # Ensure that the delete_test_image function removes the thumbnail
        # style images.
        self.assertFalse(os.path.exists(dst_thumb_file))

    def test_slice_sequences(self):
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 0, 2),
            [1, 2],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 2, 4),
            [3, 4],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 4, 6),
            [5, 6],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 6, 8),
            [7],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 0, 10),
            [1, 2, 3, 4, 5, 6, 7],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 0, 4),
            [1, 2, 3, 4],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 1, 5),
            [2, 3, 4, 5],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 3, 11),
            [4, 5, 6, 7],
        )
        self.assertEqual(
            slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 100, 200),
            [],
        )
        
    def test_describe_page_numbers(self):
        self.assertEqual(
            describe_page_numbers(1, 500, 10),
            {'current_page': 1,
             'has_next': True,
             'has_previous': False,
             'next_page': 2,
             'numbers': [1, 2, 3, 4, None, 48, 49, 50],
             'per_page': 10,
             'previous_page': 0,
             'total_count': 500}
        )

        self.assertEqual(
            describe_page_numbers(10, 500, 10),
            {'current_page': 10,
             'has_next': True,
             'has_previous': True,
             'next_page': 11,
             'numbers': [1, 2, 3, None, 7, 8, 9, 10, 11, 12, 13, None, 48, 49, 50],
             'per_page': 10,
             'previous_page': 9,
             'total_count': 500},
        )

        self.assertEqual(
            describe_page_numbers(50, 500, 10),
            {'current_page': 50,
             'has_next': False,
             'has_previous': True,
             'next_page': 51,
             'numbers': [1, 2, 3, None, 47, 48, 49, 50],
             'per_page': 10,
             'previous_page': 49,
             'total_count': 500},
        )

        self.assertEqual(
            describe_page_numbers(2, 40, 10),
            {'current_page': 2,
             'has_next': True,
             'has_previous': True,
             'next_page': 3,
             'numbers': [1, 2, 3, 4],
             'per_page': 10,
             'previous_page': 1,
             'total_count': 40},
        )

        self.assertEqual(
            # total_count / per_page == 0 - need float math
            describe_page_numbers(1, 1, 20),
            {'current_page': 1,
             'has_next': False,
             'has_previous': False,
             'next_page': 2,
             'numbers': [1],
             'per_page': 20,
             'previous_page': 0,
             'total_count': 1},
        )

        self.assertEqual(
            # empty results - total_count==0
            describe_page_numbers(1, 0, 20),
            {'current_page': 1,
             'has_next': False,
             'has_previous': False,
             'next_page': 2,
             'numbers': [],
             'per_page': 20,
             'previous_page': 0,
             'total_count': 0},
        )
