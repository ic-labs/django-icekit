import json
from pytz import timezone

from django.apps import apps
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.core.urlresolvers import reverse
from django.utils.timezone import utc, is_aware

from rest_framework.test import APITestCase

from django_dynamic_fixture import G

from rest_framework.authtoken.models import Token


User = get_user_model()
Image = apps.get_model('icekit_plugins_image.Image')

TZ = timezone(settings.TIME_ZONE)


class _BaseAPITestCase(APITestCase):
    API_NAME = None  # Set to reverse-able name for API URLs
    API_IS_PUBLIC_READ = False
    BASE_DATA = {}

    def __init__(self, *args, **kwargs):
        if not self.API_NAME:
            raise Exception(
                "Subclasses of %s must define the class attribute"
                " 'API_NAME'" % _BaseAPITestCase)
        super(_BaseAPITestCase, self).__init__(*args, **kwargs)

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

        # Act as authenticated `superuser` by default
        self.client_apply_token(self.superuser_token)

    def pp_data(self, data, indent=4):
        """ Pretty-print data to stdout, to help debugging unit tests """
        print(json.dumps(data, indent=indent))

    def iso8601(self, dt):
        """
        Return given datetime as UTC time in ISO 8601 format, cleaned up to
        use trailing 'Z' instead of rubbish like '+00:00'.

        Based on https://gist.github.com/bryanchow/1195854
        """
        if not is_aware(dt):
            dt = TZ.localize(dt)
        #dt = dt.replace(microsecond=0)
        return dt.astimezone(utc).replace(tzinfo=None).isoformat() + 'Z'

    def build_item_data(self, extend_data, base_data=None):
        if base_data is None:
            base_data = self.BASE_DATA
        return dict(base_data, **extend_data)

    def listing_url(self):
        """ Return the listing URL endpoint for this class's API """
        return reverse('api:%s-list' % self.API_NAME)

    def detail_url(self, id):
        """
        Return the detail URL endpoint for a given ID in this class's API
        """
        return reverse('api:%s-detail' % self.API_NAME, args=[id])

    def client_apply_token(self, token):
        """
        Apply the given token as token auth credentials for all follow-up
        requests from the client until reset by `self.client.credentials()`
        """
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token.key)

    def test_supports_session_authentication(self):
        """ Confirm the API supports session-based authentication """
        self.client.credentials()  # Clear any user credentials

        if self.API_IS_PUBLIC_READ:
            # Request without login is accepted
            response = self.client.get(self.listing_url())
            self.assertEqual(200, response.status_code)
        else:
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

    def test_supports_token_authentication(self):
        """ Confirm the API supports token-based authentication """
        self.client.credentials()  # Clear any user credentials

        if self.API_IS_PUBLIC_READ:
            # Request without token is accepted
            response = self.client.get(self.listing_url())
            self.assertEqual(200, response.status_code)
        else:
            # Request without token is rejected
            response = self.client.get(self.listing_url())
            self.assertEqual(403, response.status_code)

            # Request with token is accepted
            response = self.client.get(
                self.listing_url(),
                HTTP_AUTHORIZATION='Token %s' % self.superuser_token.key,
            )
            self.assertEqual(200, response.status_code)

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

    def assert_user_has_post_permission(
        self, permitted, item_data=None, format='json'
    ):
        response = self.client.post(
            self.listing_url(),
            item_data or {},
            format=format,
        )
        if permitted:
            self.assertEqual(201, response.status_code)
        else:
            # Response may be 403 or 405 for rejected POST
            self.assertTrue(response.status_code in (403, 405))

    def assert_user_has_put_permission(
        self, permitted, item_id, item_data=None, format='json'
    ):
        response = self.client.put(
            self.detail_url(item_id),
            item_data or {},
            format=format,
        )
        if permitted:
            self.assertEqual(200, response.status_code)
        else:
            # Response may be 403 or 405 for rejected POST
            self.assertTrue(response.status_code in (403, 405))

    def assert_user_has_patch_permission(
        self, permitted, item_id, item_data=None, format='json'
    ):
        response = self.client.patch(
            self.detail_url(item_id),
            item_data or {},
            format=format,
        )
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

    def assert_api_user_permissions_are_correct(
        self, item_id, item_model=None, item_admin_name=None,
        format='json', extra_item_data_for_writes_fn=lambda: {},
        item_data_fields_to_remove=None,
    ):
        self.client.credentials()  # Clear any user credentials

        if self.API_IS_PUBLIC_READ:
            # Anonymous user can peform all read operations, no writes
            self.client.credentials()  # Clear any user credentials
            self.assert_user_has_get_list_permission(True)
            self.assert_user_has_get_detail_permission(True, item_id)
            self.assert_user_has_post_permission(False)
            self.assert_user_has_put_permission(False, item_id)
            self.assert_user_has_patch_permission(False, item_id)
            self.assert_user_has_delete_permission(False, item_id)

            # Even superuser cannot peform write operations
            self.client_apply_token(self.superuser_token)
            self.assert_user_has_get_list_permission(True)
            self.assert_user_has_get_detail_permission(True, item_id)
            self.assert_user_has_post_permission(False)
            self.assert_user_has_put_permission(False, item_id)
            self.assert_user_has_patch_permission(False, item_id)
            self.assert_user_has_delete_permission(False, item_id)

            return  # Read-only public APIs need no further tests

        item_ct = ContentType.objects.get_for_model(item_model)

        # Anonymous user cannot do anything (no `user` provided)
        self.assert_user_has_get_list_permission(False)
        self.assert_user_has_get_detail_permission(False, item_id)
        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(False, item_id)
        self.assert_user_has_patch_permission(False, item_id)
        self.assert_user_has_delete_permission(False, item_id)

        # Authenticate in test client as `self.active_user`
        self.client_apply_token(self.active_user_token)

        # User without explicit model permissions cannot do anything
        self.assert_user_has_get_list_permission(False)
        self.assert_user_has_get_detail_permission(False, item_id)
        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(False, item_id)
        self.assert_user_has_patch_permission(False, item_id)
        self.assert_user_has_delete_permission(False, item_id)

        # User with 'change' model permissions can list and change existing
        # items but not add or delete
        self.active_user.user_permissions = [
            Permission.objects.get(
                content_type=item_ct, codename='change_%s' % item_admin_name)
        ]
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, item_id)

        # Get item data for later submission
        item_data = self.client.get(self.detail_url(item_id)).data
        if item_data_fields_to_remove:
            for field in item_data_fields_to_remove:
                if field in item_data:
                    del(item_data[field])

        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(
            True,
            item_id,
            dict(item_data, **extra_item_data_for_writes_fn()),
            format=format,
        )
        self.assert_user_has_patch_permission(True, item_id)
        self.assert_user_has_delete_permission(False, item_id)

        # User with 'change' and 'add' model permissions can list and change
        # existing items and add new ones, but not delete
        self.active_user.user_permissions = [
            Permission.objects.get(
                content_type=item_ct, codename='change_%s' % item_admin_name),
            Permission.objects.get(
                content_type=item_ct, codename='add_%s' % item_admin_name),
        ]
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, item_id)
        self.assert_user_has_post_permission(
            True,
            extra_item_data_for_writes_fn(),
            format=format,
        )
        self.assert_user_has_put_permission(
            True,
            item_id,
            dict(item_data, **extra_item_data_for_writes_fn()),
            format=format,
        )
        self.assert_user_has_patch_permission(True, item_id)
        self.assert_user_has_delete_permission(False, item_id)

        # User with 'change', 'add', and 'delete' model permissions can do
        # everything
        self.active_user.user_permissions = [
            Permission.objects.get(
                content_type=item_ct, codename='change_%s' % item_admin_name),
            Permission.objects.get(
                content_type=item_ct, codename='add_%s' % item_admin_name),
            Permission.objects.get(
                content_type=item_ct, codename='delete_%s' % item_admin_name)
        ]
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, item_id)
        self.assert_user_has_post_permission(
            True,
            extra_item_data_for_writes_fn(),
            format=format,
        )
        self.assert_user_has_put_permission(
            True,
            item_id,
            dict(item_data, **extra_item_data_for_writes_fn()),
            format=format,
        )
        self.assert_user_has_patch_permission(True, item_id)
        self.assert_user_has_delete_permission(True, item_id)
