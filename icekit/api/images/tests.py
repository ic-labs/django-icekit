from django.apps import apps
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.core.urlresolvers import reverse

from django_webtest import WebTest
from django_dynamic_fixture import G

from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token

from icekit.utils.testing import get_test_image, setup_with_context_manager


User = get_user_model()
Image = apps.get_model('icekit_plugins_image.Image')


class ImageAPITests(APITestCase):

    def setUp(self):
        self.superuser = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.superuser.set_password('password')
        self.superuser.save()

        self.user = G(
            User,
            is_active=True,
        )
        self.user.set_password('password')
        self.user.save()

        self.superuser_token = Token.objects.create(user=self.superuser)
        self.user_token = Token.objects.create(user=self.user)

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

    def test_anonymous_user_rejected(self):
        response = self.client.get(
            reverse('images-list'))
        self.assertEqual(403, response.status_code)

        response = self.client.get(
            reverse('images-detail', args=[self.image.pk]))
        self.assertEqual(403, response.status_code)

        response = self.client.put(
            reverse('images-list'))
        self.assertEqual(403, response.status_code)

        response = self.client.patch(
            reverse('images-detail', args=[self.image.pk]))
        self.assertEqual(403, response.status_code)

        response = self.client.delete(
            reverse('images-detail', args=[self.image.pk]))
        self.assertEqual(403, response.status_code)

    def test_session_authentication(self):
        self.assertTrue(
            self.client.login(
                username=self.superuser.email,
                password='password',
            )
        )
        response = self.client.get(
            reverse('images-list'),
        )
        self.assertEqual(200, response.status_code)

    def test_token_authentication(self):
        # Request without token is rejected
        response = self.client.get(
            reverse('images-list'))
        self.assertEqual(403, response.status_code)
        # Request with token is accepted
        response = self.client.get(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key,
        )
        self.assertEqual(200, response.status_code)

    def test_list_images_with_get(self):
        response = self.client.get(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key)
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
        response = self.client.get(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key)
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
            reverse('images-list'),
            {
                'title': 'New image',
                'image': open(self.image.image.file.name, 'rb'),
            },
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key,
        )
        self.assertEqual(201, response.status_code)
        new_image = Image.objects.get(pk=response.data['id'])
        self.assertEqual('New image', new_image.title)

    def test_replace_image_with_put(self):
        response = self.client.get(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key)
        self.assertEqual(200, response.status_code)

        image_data = response.data
        image_data['title'] = 'Updated image'
        image_data['image'] = open(self.image.image.file.name, 'rb')

        response = self.client.put(
            reverse('images-detail', args=[self.image.pk]),
            image_data,
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key,
        )
        self.assertEqual(200, response.status_code)
        updated_image = Image.objects.get(pk=self.image.pk)
        self.assertEqual('Updated image', updated_image.title)

    def test_delete_image_with_delete(self):
        response = self.client.delete(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key)
        self.assertEqual(204, response.status_code)
        self.assertEqual(0, Image.objects.count())

    def test_django_model_permissons(self):
        # User without any model permissions cannot do anything
        response = self.client.get(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(403, response.status_code)

        response = self.client.get(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(403, response.status_code)

        response = self.client.post(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key,
        )
        self.assertEqual(403, response.status_code)

        response = self.client.put(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(403, response.status_code)

        response = self.client.patch(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(403, response.status_code)

        response = self.client.delete(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(403, response.status_code)

        # User with 'change' model permissions can list and change existing
        # but not add or delete
        self.user.user_permissions = [
            Permission.objects.get(
                content_type=self.image_ct, codename='change_image')
        ]

        response = self.client.get(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.get(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        image_data = response.data

        response = self.client.post(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key,
        )
        self.assertEqual(403, response.status_code)

        image_data['image'] = open(self.image.image.file.name, 'rb')
        response = self.client.put(
            reverse('images-detail', args=[self.image.pk]),
            image_data,
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key,
        )
        self.assertEqual(200, response.status_code)

        response = self.client.patch(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.delete(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(403, response.status_code)

        # User with 'change' and 'add' model permissions can list and change
        # existing items and add new ones, but not delete
        self.user.user_permissions = [
            Permission.objects.get(
                content_type=self.image_ct, codename='change_image'),
            Permission.objects.get(
                content_type=self.image_ct, codename='add_image'),
        ]

        response = self.client.get(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.get(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.post(
            reverse('images-list'),
            {
                'title': 'New image',
                'image': open(self.image.image.file.name, 'rb'),
            },
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key,
        )
        self.assertEqual(201, response.status_code)

        image_data['image'] = open(self.image.image.file.name, 'rb')
        response = self.client.put(
            reverse('images-detail', args=[self.image.pk]),
            image_data,
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key,
        )
        self.assertEqual(200, response.status_code)

        response = self.client.patch(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.delete(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(403, response.status_code)

        # User with 'change', 'add', and 'delete' model permissions can do
        # everything
        self.user.user_permissions = [
            Permission.objects.get(
                content_type=self.image_ct, codename='change_image'),
            Permission.objects.get(
                content_type=self.image_ct, codename='add_image'),
            Permission.objects.get(
                content_type=self.image_ct, codename='delete_image')
        ]

        response = self.client.get(
            reverse('images-list'),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.get(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.post(
            reverse('images-list'),
            {
                'title': 'New image',
                'image': open(self.image.image.file.name, 'rb'),
            },
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key,
        )
        self.assertEqual(201, response.status_code)

        image_data['image'] = open(self.image.image.file.name, 'rb')
        response = self.client.put(
            reverse('images-detail', args=[self.image.pk]),
            image_data,
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.patch(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(200, response.status_code)

        response = self.client.delete(
            reverse('images-detail', args=[self.image.pk]),
            HTTP_AUTHORIZATION='Token %s' % self.user_token.key)
        self.assertEqual(204, response.status_code)
