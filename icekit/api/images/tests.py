from django_dynamic_fixture import G

from icekit.utils.testing import get_test_image, setup_with_context_manager

from .. import base_tests
from ..base_tests import Image


class ImageAPITests(base_tests._BaseAPITestCase):
    API_NAME = 'images-api'

    def setUp(self):
        super(ImageAPITests, self).setUp()

        self.image = G(
            Image,
            title='Test Image',
            width=800,
            height=600,
        )
        self._image_name = setup_with_context_manager(
            self, get_test_image(self.image.image.storage)
        )  # context is automatically exited on teardown.
        self.image.image = self._image_name
        self.image.save()

    def test_list_images_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        self.assertEqual(
            {
                'count': 1,
                'next': None,
                'previous': None,
                'results': [{
                    'id': self.image.pk,
                    'image': 'http://testserver%s' % self.image.image.url,
                    'width': self.image.width,
                    'height': self.image.height,
                    'title': self.image.title,
                    'alt_text': self.image.alt_text,
                    'caption': self.image.caption,
                    'credit': self.image.credit,
                    'source': self.image.source,
                    'external_ref': self.image.external_ref,
                    'categories': list(self.image.categories.all()),
                    'license': self.image.license,
                    'notes': self.image.notes,
                    'date_created': self.image.date_created
                        .strftime(u'%Y-%m-%dT%H:%M:%S.%fZ'),
                    'date_modified': self.image.date_modified
                        .strftime(u'%Y-%m-%dT%H:%M:%S.%fZ'),
                    'is_ok_for_web': self.image.is_ok_for_web,
                    'is_cropping_allowed': self.image.is_cropping_allowed,
                }]
            },
            response.data)

    def test_get_image_detail_with_get(self):
        response = self.client.get(self.detail_url(self.image.pk))
        self.assertEqual(200, response.status_code)
        self.assertEqual(
            {
                'id': self.image.pk,
                'image': 'http://testserver%s' % self.image.image.url,
                'width': self.image.width,
                'height': self.image.height,
                'title': self.image.title,
                'alt_text': self.image.alt_text,
                'caption': self.image.caption,
                'credit': self.image.credit,
                'source': self.image.source,
                'external_ref': self.image.external_ref,
                'categories': list(self.image.categories.all()),
                'license': self.image.license,
                'notes': self.image.notes,
                'date_created': self.image.date_created
                    .strftime(u'%Y-%m-%dT%H:%M:%S.%fZ'),
                'date_modified': self.image.date_modified
                    .strftime(u'%Y-%m-%dT%H:%M:%S.%fZ'),
                'is_ok_for_web': self.image.is_ok_for_web,
                'is_cropping_allowed': self.image.is_cropping_allowed,
            },
            response.data)

    def test_add_image_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'title': 'New image',
                'image': open(self.image.image.file.name, 'rb'),
            },
            format='multipart',  # Cannot upload image with JSON
        )
        self.assertEqual(201, response.status_code)
        new_image = Image.objects.get(pk=response.data['id'])
        self.assertEqual('New image', new_image.title)

    def test_replace_image_with_put(self):
        response = self.client.get(self.detail_url(self.image.pk))
        self.assertEqual(200, response.status_code)

        image_data = response.data
        image_data['title'] = 'Replaced image'
        image_data['image'] = open(self.image.image.file.name, 'rb')

        response = self.client.put(
            self.detail_url(self.image.pk),
            image_data,
            format='multipart',  # Cannot upload image with JSON
        )
        self.assertEqual(200, response.status_code)
        updated_image = Image.objects.get(pk=self.image.pk)
        self.assertEqual('Replaced image', updated_image.title)

    def test_update_image_with_patch(self):
        response = self.client.patch(
            self.detail_url(self.image.pk),
            {'title': 'Updated image'},
        )
        self.assertEqual(200, response.status_code)
        updated_image = Image.objects.get(pk=self.image.pk)
        self.assertEqual('Updated image', updated_image.title)

    def test_delete_image_with_delete(self):
        response = self.client.delete(self.detail_url(self.image.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, Image.objects.count())

    def test_api_user_permissions_are_correct(self):
        self.assert_api_user_permissions_are_correct(
            self.image.pk,
            Image,
            'image',
            format='multipart',
            extra_item_data_for_writes_fn=lambda: {
                'image': open(self.image.image.file.name, 'rb'),
            }
        )
