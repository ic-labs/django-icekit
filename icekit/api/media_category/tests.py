from django.apps import apps
from django_dynamic_fixture import G
from .. import base_tests

MediaCategory = apps.get_model('icekit.MediaCategory')


class MediaCategoryAPITests(base_tests._BaseAPITestCase):
    API_NAME = 'media-category-api'

    def setUp(self):
        super(MediaCategoryAPITests, self).setUp()

        self.media_category = G(
            MediaCategory,
            name='Test media category',
        )

    def test_list_media_categories_with_get(self):
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)
        self.assertEqual(
            {
                'count': 1,
                'next': None,
                'previous': None,
                'results': [{
                    'id': self.media_category.pk,
                    'name': 'Test media category',
                }]
            },
            response.data)

    def test_get_media_category_detail_with_get(self):
        response = self.client.get(self.detail_url(self.media_category.pk))
        self.assertEqual(200, response.status_code)
        self.assertEqual(
            {
                'id': self.media_category.pk,
                'name': 'Test media category',
            },
            response.data)

    def test_add_media_category_with_post(self):
        response = self.client.post(
            self.listing_url(),
            {
                'name': 'New media category',
            },
        )
        self.assertEqual(201, response.status_code)
        new_media_category = MediaCategory.objects.get(pk=response.data['id'])
        self.assertEqual('New media category', new_media_category.name)

    def test_replace_media_category_with_put(self):
        response = self.client.get(self.detail_url(self.media_category.pk))
        self.assertEqual(200, response.status_code)

        media_category_data = response.data
        media_category_data['name'] = 'Replaced media category'

        response = self.client.put(
            self.detail_url(self.media_category.pk),
            media_category_data,
        )
        self.assertEqual(200, response.status_code)
        updated_media_category = MediaCategory.objects.get(pk=self.media_category.pk)
        self.assertEqual('Replaced media category', updated_media_category.name)

    def test_update_media_category_with_patch(self):
        response = self.client.patch(
            self.detail_url(self.media_category.pk),
            {'name': 'Updated media category'},
        )
        self.assertEqual(200, response.status_code)
        updated_media_category = MediaCategory.objects.get(pk=self.media_category.pk)
        self.assertEqual('Updated media category', updated_media_category.name)

    def test_delete_media_category_with_delete(self):
        response = self.client.delete(self.detail_url(self.media_category.pk))
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, MediaCategory.objects.count())

    def test_api_user_permissions_are_correct(self):

        def extra_item_data_for_writes_fn():
            return {
                'name': "Test Media Category %d" % self.get_unique_int()
            }

        self.assert_api_user_permissions_are_correct(
            self.media_category.pk,
            item_model=MediaCategory,
            item_admin_name='mediacategory',
            extra_item_data_for_writes_fn=extra_item_data_for_writes_fn,
        )
