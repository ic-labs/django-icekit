from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType

from django_dynamic_fixture import G

from icekit.utils.testing import get_test_image, setup_with_context_manager

from ..base_tests import BaseAPITestCase, Image


class ImageAPITests(BaseAPITestCase):
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

        self.image_ct = ContentType.objects.get_for_model(Image)

        # Act as authenticated `superuser` by default
        self.client_apply_token(self.superuser_token)

    def test_session_authentication(self):
        self.client.credentials()  # Clear any user credentials

        # Request without login is rejected
        response = self.client.get(self.listing_url())
        self.assertEqual(403, response.status_code)

        self.assertTrue(
            self.client.login(
                username=self.superuser.email,
                password='password',
            )
        )

        # Request after login is accepted
        response = self.client.get(self.listing_url())
        self.assertEqual(200, response.status_code)

    def test_token_authentication(self):
        self.client.credentials()  # Clear any user credentials

        # Request without token is rejected
        response = self.client.get(self.listing_url())
        self.assertEqual(403, response.status_code)

        # Request with token is accepted
        response = self.client.get(
            self.listing_url(),
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key,
        )
        self.assertEqual(200, response.status_code)

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
        # Anonymous user cannot do anything (no `user` provided)
        self.client.credentials()  # Clear any user credentials
        self.assert_user_has_get_list_permission(False)
        self.assert_user_has_get_detail_permission(False, self.image.pk)
        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(False, self.image.pk)
        self.assert_user_has_patch_permission(False, self.image.pk)
        self.assert_user_has_delete_permission(False, self.image.pk)

        # Authenticate in test client as `self.active_user`
        self.client_apply_token(self.active_user_token)

        # User without explicit model permissions cannot do anything
        self.assert_user_has_get_list_permission(False)
        self.assert_user_has_get_detail_permission(False, self.image.pk)
        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(False, self.image.pk)
        self.assert_user_has_patch_permission(False, self.image.pk)
        self.assert_user_has_delete_permission(False, self.image.pk)

        # User with 'change' model permissions can list and change existing
        # images but not add or delete
        self.active_user.user_permissions = [
            Permission.objects.get(
                content_type=self.image_ct, codename='change_image')
        ]
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, self.image.pk)

        # Get image data for later submission
        image_data = self.client.get(self.detail_url(self.image.pk)).data

        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(
            True,
            self.image.pk,
            dict(image_data, **{
                'image': open(self.image.image.file.name, 'rb'),
            }),
            format='multipart',  # Cannot upload image with JSON
        )
        self.assert_user_has_patch_permission(True, self.image.pk)
        self.assert_user_has_delete_permission(False, self.image.pk)

        # User with 'change' and 'add' model permissions can list and change
        # existing items and add new ones, but not delete
        self.active_user.user_permissions = [
            Permission.objects.get(
                content_type=self.image_ct, codename='change_image'),
            Permission.objects.get(
                content_type=self.image_ct, codename='add_image'),
        ]
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, self.image.pk)
        self.assert_user_has_post_permission(
            True,
            {
                'title': 'New image',
                'image': open(self.image.image.file.name, 'rb'),
            },
            format='multipart',  # Cannot upload image with JSON
        )
        self.assert_user_has_put_permission(
            True,
            self.image.pk,
            dict(image_data, **{
                'image': open(self.image.image.file.name, 'rb'),
            }),
            format='multipart',  # Cannot upload image with JSON
        )
        self.assert_user_has_patch_permission(True, self.image.pk)
        self.assert_user_has_delete_permission(False, self.image.pk)

        # User with 'change', 'add', and 'delete' model permissions can do
        # everything
        self.active_user.user_permissions = [
            Permission.objects.get(
                content_type=self.image_ct, codename='change_image'),
            Permission.objects.get(
                content_type=self.image_ct, codename='add_image'),
            Permission.objects.get(
                content_type=self.image_ct, codename='delete_image')
        ]
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, self.image.pk)
        self.assert_user_has_post_permission(
            True,
            {
                'title': 'New image',
                'image': open(self.image.image.file.name, 'rb'),
            },
            format='multipart',  # Cannot upload image with JSON
        )
        self.assert_user_has_put_permission(
            True,
            self.image.pk,
            dict(image_data, **{
                'image': open(self.image.image.file.name, 'rb'),
            }),
            format='multipart',  # Cannot upload image with JSON
        )
        self.assert_user_has_patch_permission(True, self.image.pk)
        self.assert_user_has_delete_permission(True, self.image.pk)
