from django.contrib.auth import get_user_model
from django.contrib.sites.models import Site
from django.core.urlresolvers import reverse
from django_dynamic_fixture import G
from django_webtest import WebTest
from fluent_contents.models import Placeholder

from ..models import Author
from models import AuthorsPage
from icekit.models import Layout

User = get_user_model()

class AuthorTests(WebTest):
    def setUp(self):
        self.staff_1 = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        self.layout_1 = G(
            Layout,
            template_name='icekit_authors_page/authorspage/layouts/default.html',
        )

        self.author_listing_page = AuthorsPage.objects.create(
            parent_site=Site.objects.first(),
            author=self.staff_1,
            title='listing page',
            slug='listing-page',
            layout=self.layout_1,
        )

        self.author_1 = G(Author)
        self.author_2 = G(Author)

        # Create the placeholder manually as we aren't using the admin view which normally creates
        # the placeholders for us.
        placeholder_1 = Placeholder.objects.create_for_object(
            self.author_1,
            'author_content'
        )

    def test_str(self):
        self.assertEqual(str(self.author_1), self.author_1.get_full_name())

    def test_get_absolute_url(self):
        # Authors should live under the listing url
        # TODO: don't care if the page is published
        self.author_listing_page.publish()
        self.assertEqual(
            self.author_1.get_absolute_url(),
            '%s%s/' % (
                self.author_listing_page.get_published().get_absolute_url(),
                self.author_1.slug
            )
        )
        self.author_listing_page.unpublish()

    def test_render(self):
        # The listing page is not published, so there is no view for authors.
        response = self.app.get(self.author_1.get_absolute_url(), expect_errors=True)
        self.assertEqual(response.status_code, 404)

        # unless staff, who are redirected to the draft view
        response = self.app.get(self.author_1.get_absolute_url(), expect_errors=True, user=self.staff_1)
        self.assertEqual(response.status_code, 302)

        # We need to publish the listing page before we can view authors (though this isn't desirable)
        self.author_listing_page.publish()

        # the listing page should not contain the author unless published (or staff)
        response = self.app.get(self.author_listing_page.get_absolute_url())
        self.assertEqual(response.status_code, 200)
        response.mustcontain(no=[self.author_1.get_full_name()])

        # if we publish the author, it should show.
        self.author_1.publish()

        response = self.app.get(self.author_listing_page.get_absolute_url())
        self.assertEqual(response.status_code, 200)
        response.mustcontain(self.author_1.get_full_name())

        # Be nice and reset to the default state
        self.author_1.unpublish()
        self.author_listing_page.unpublish()

    def test_admin(self):
        admin_app_list = (
            ('icekit_authors_page_authorspage', self.author_listing_page),
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
