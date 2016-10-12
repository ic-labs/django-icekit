from django.contrib.auth import get_user_model
from django.core.urlresolvers import reverse
from django_dynamic_fixture import G
from django_webtest import WebTest
from fluent_contents.models import Placeholder

from . import models

User = get_user_model()

class AuthorTests(WebTest):
    def setUp(self):
        self.staff_1 = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        # used to make the author's URL
        self.author_listing = models.AuthorListing.objects.create(
            author=self.staff_1,
            title="Authors",
            slug="authors",
        )

        self.author_1 = G(models.Author)
        self.author_2 = G(models.Author)

    def test_get_absolute_url(self):
        self.assertEqual(
            self.author_1.get_absolute_url(),
            '/authors/%s/' % (
                self.author_1.slug
            )
        )

    def test_admin(self):
        admin_app_list = (
            ('icekit_authors_author', self.author_1),
        )

        for admin_app, obj in admin_app_list:
            response = self.app.get(
                reverse('admin:%s_changelist' % admin_app),
                user=self.staff_1
            )
            self.assertEqual(response.status_code, 200)
            response = self.app.get(reverse('admin:%s_add' % admin_app), user=self.staff_1)
            self.assertEqual(response.status_code, 200)
            response = self.app.get(
                reverse('admin:%s_history' % admin_app, args=(obj.id,)),
                user=self.staff_1
            )
            self.assertEqual(response.status_code, 200)
            response = self.app.get(
                reverse('admin:%s_delete' % admin_app, args=(obj.id,)),
                user=self.staff_1
            )
            self.assertEqual(response.status_code, 200)
            response = self.app.get(
                reverse('admin:%s_change' % admin_app, args=(obj.id,)),
                user=self.staff_1
            )
            self.assertEqual(response.status_code, 200)
