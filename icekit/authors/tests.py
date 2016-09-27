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

        self.author_listing = models.AuthorListing.objects.create(
            author=self.staff_1,
            title="Authors",
            slug="authors",
        )

        self.author_1 = G(models.Author)
        self.author_2 = G(models.Author)

        # Create the placeholder manually as we aren't using the admin view which normally creates
        # the placeholders for us.
        placeholder_1 = Placeholder.objects.create_for_object(
            self.author_1,
            'author_content'
        )

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

        no_history = ()

        for admin_app, obj in admin_app_list:
            response = self.app.get(
                reverse('admin:%s_changelist' % admin_app),
                user=self.staff_1
            )
            self.assertEqual(response.status_code, 200)
            response = self.app.get(reverse('admin:%s_add' % admin_app), user=self.staff_1)
            self.assertEqual(response.status_code, 200)
            if obj not in no_history:
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
