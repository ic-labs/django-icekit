from django.apps import apps
from django.contrib.auth import get_user_model
from django.core.urlresolvers import reverse

from rest_framework.test import APITestCase

from django_dynamic_fixture import G

from rest_framework.authtoken.models import Token


User = get_user_model()
Image = apps.get_model('icekit_plugins_image.Image')


class BaseAPITestCase(APITestCase):
    API_NAME = None  # Set to reverse-able name for API URLs

    def __init__(self, *args, **kwargs):
        if not self.API_NAME:
            raise Exception(
                "Subclasses of %s must define the class attribute"
                " 'API_NAME'" % BaseAPITestCase)
        super(BaseAPITestCase, self).__init__(*args, **kwargs)

    def setUp(self):
        # Set up superuser and token
        self.superuser = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.superuser.set_password('password')
        self.superuser.save()

        self.superuser_token = Token.objects.create(user=self.superuser)

        # Set up active non-staff user and token
        self.active_user = G(
            User,
            is_active=True,
        )
        self.active_user.set_password('password')
        self.active_user.save()

        self.active_user_token = Token.objects.create(user=self.active_user)

    def listing_url(self):
        """ Return the listing URL endpoint for this class's API """
        return reverse('%s-list' % self.API_NAME)

    def detail_url(self, id):
        """
        Return the detail URL endpoint for a given ID in this class's API
        """
        return reverse('%s-detail' % self.API_NAME, args=[id])

    def client_apply_token(self, token):
        """
        Apply the given token as token auth credentials for all follow-up
        requests from the client until reset by `self.client.credentials()`
        """
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token.key)

    def assert_user_has_get_list_permission(self, permitted):
        response = self.client.get(self.listing_url())
        self.assertEqual(
            permitted and 200 or 403,
            response.status_code)

    def assert_user_has_get_detail_permission(self, permitted, item_id):
        response = self.client.get(self.detail_url(item_id))
        self.assertEqual(
            permitted and 200 or 403,
            response.status_code)

    def assert_user_has_post_permission(self, permitted, item_data=None):
        response = self.client.post(
            self.listing_url(), item_data or {})
        if permitted:
            self.assertEqual(201, response.status_code)
        else:
            # Response may be 403 or 405 for rejected POST
            self.assertTrue(response.status_code in (403, 405))

    def assert_user_has_put_permission(
        self, permitted, item_id, item_data=None
    ):
        response = self.client.put(
            self.detail_url(item_id), item_data or {})
        if permitted:
            self.assertEqual(200, response.status_code)
        else:
            # Response may be 403 or 405 for rejected POST
            self.assertTrue(response.status_code in (403, 405))

    def assert_user_has_patch_permission(
        self, permitted, item_id, item_data=None
    ):
        response = self.client.patch(
            self.detail_url(item_id), item_data or {})
        if permitted:
            self.assertEqual(200, response.status_code)
        else:
            # Response may be 403 or 405 for rejected POST
            self.assertTrue(response.status_code in (403, 405))

    def assert_user_has_delete_permission(self, permitted, item_id):
        response = self.client.delete(self.detail_url(item_id))
        if permitted:
            self.assertEqual(204, response.status_code)
        else:
            # Response may be 403 or 405 for rejected POST
            self.assertTrue(response.status_code in (403, 405))
