from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model
from django.core import exceptions
from django_dynamic_fixture import G
from django_webtest import WebTest
from mock import Mock
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents

from . import forms, models

User = get_user_model()


class InstagramEmbedItemTestCase(WebTest):
    def setUp(self):
        self.layout_1 = G(
            Layout,
            template_name='layout_page/layoutpage/layouts/default.html',
        )
        self.layout_1.content_types.add(ContentType.objects.get_for_model(LayoutPage))
        self.layout_1.save()
        self.staff_1 = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.page_1 = LayoutPage.objects.create(
            title='Test Page',
            slug='test-page',
            parent_site=Site.objects.first(),
            layout=self.layout_1,
            author=self.staff_1,
            status='p',  # Publish the page
        )
        self.instagram_1 = fluent_contents.create_content_instance(
            models.InstagramEmbedItem,
            self.page_1,
            url='http://instagram.com/p/adasdads'
        )
        self.instagram_2 = fluent_contents.create_content_instance(
            models.InstagramEmbedItem,
            self.page_1,
            url='https://instagram.com/p/6NqtLDqdXD'
        )
        self.instagram_3 = fluent_contents.create_content_instance(
            models.InstagramEmbedItem,
            self.page_1,
            url='https://instagram.com/p/5O26siFtv8/'
        )

    def test_str(self):
        self.assertEqual(str(self.instagram_1), 'Instagram Embed: %s' % self.instagram_1.url)

    def test_clean(self):
        initial_fetch_instagram_data = self.instagram_1.fetch_instagram_data
        self.instagram_1.fetch_instagram_data = Mock(
            return_value='Please provide a valid link.'
        )

        with self.assertRaises(exceptions.ValidationError):
            self.instagram_1.clean()

        self.instagram_1.fetch_instagram_data = initial_fetch_instagram_data
        initial_fetch_instagram_data = self.instagram_2.fetch_instagram_data
        self.instagram_2.fetch_instagram_data = Mock(
            return_value={
                'provider_url': 'https://instagram.com/',
                'media_id': 'asdasdsad',
                'version': '1.0',
                'title': 'A title',
                'html': '<p>html</p>',
                'thumbnail_width': 612,
                'height': None,
                'width': 658,
                'thumbnail_url': '',
                'author_name': 'test',
                'author_id': 2091,
                'thumbnail_height': 612,
                'type': 'rich',
                'provider_name': 'Instagram',
                'author_url': 'https://instagram.com/test'
            }
        )
        self.instagram_2.clean()
        self.instagram_2.fetch_instagram_data = initial_fetch_instagram_data
        self.assertEqual(self.instagram_2.provider_url, 'https://instagram.com/')

    def test_get_thumbnail(self):
        initial_fetch_instagram_data = self.instagram_2.fetch_instagram_data
        self.instagram_2.fetch_instagram_data = Mock(
            return_value={
                'provider_url': 'https://instagram.com/',
                'media_id': 'asdasdsad',
                'version': '1.0',
                'title': 'A title',
                'html': '<p>html</p>',
                'thumbnail_width': 612,
                'height': None,
                'width': 658,
                'thumbnail_url': '',
                'author_name': 'test',
                'author_id': 2091,
                'thumbnail_height': 612,
                'type': 'rich',
                'provider_name': 'Instagram',
                'author_url': 'https://instagram.com/test'
            }
        )
        self.instagram_2.clean()
        self.instagram_2.fetch_instagram_data = initial_fetch_instagram_data

        initial_fetch_instagram_data = self.instagram_3.fetch_instagram_data
        self.instagram_3.fetch_instagram_data = Mock(
            return_value={
                'provider_url': 'https://instagram.com/',
                'media_id': 'asdasdsad',
                'version': '1.0',
                'title': 'A title',
                'html': '<p>html</p>',
                'thumbnail_width': 612,
                'height': None,
                'width': 658,
                'thumbnail_url': 'https://thubmanil_url.com/1/',
                'author_name': 'test',
                'author_id': 2091,
                'thumbnail_height': 612,
                'type': 'rich',
                'provider_name': 'Instagram',
                'author_url': 'https://instagram.com/test'
            }
        )
        self.instagram_3.clean()
        self.instagram_3.fetch_instagram_data = initial_fetch_instagram_data
        self.assertEqual(self.instagram_1.get_thumbnail(), '')
        self.assertEqual(self.instagram_2.get_thumbnail(), self.instagram_2.thumbnail_url)
        self.assertNotEquals(self.instagram_3.get_thumbnail(), '')
        self.assertEqual(self.instagram_3.get_thumbnail(), self.instagram_3.thumbnail_url)

    def test_get_default_embed(self):
        initial_fetch_instagram_data = self.instagram_2.fetch_instagram_data
        self.instagram_2.fetch_instagram_data = Mock(
            return_value={
                'provider_url': 'https://instagram.com/',
                'media_id': 'asdasdsad',
                'version': '1.0',
                'title': 'A title',
                'html': '<p>html</p>',
                'thumbnail_width': 612,
                'height': None,
                'width': 658,
                'thumbnail_url': '',
                'author_name': 'test',
                'author_id': 2091,
                'thumbnail_height': 612,
                'type': 'rich',
                'provider_name': 'Instagram',
                'author_url': 'https://instagram.com/test'
            }
        )
        self.instagram_2.clean()
        self.instagram_2.fetch_instagram_data = initial_fetch_instagram_data
        self.assertEqual(self.instagram_1.get_default_embed(), '')
        self.assertEqual(self.instagram_2.get_default_embed(), self.instagram_2.html)

    def test_forms(self):
        class InstagramEmbedAdminForm(forms.InstagramEmbedAdminForm):
            class Meta:
                fields = '__all__'
                model = models.InstagramEmbedItem

        form = InstagramEmbedAdminForm(
            {
                'parent_id': self.page_1.id,
                'sort_order': 4,
                'parent_type': ContentType.objects.get_for_model(type(self.page_1)).id,
                'url': 'https://instagram.com/p/5O26siFtv8/',
            }
        )

        initial_fetch_instagram_data = form.instance.fetch_instagram_data
        form.instance.fetch_instagram_data = Mock(
            return_value={
                'provider_url': 'https://instagram.com/',
                'media_id': 'asdasdsad',
                'version': '1.0',
                'title': 'A title',
                'html': '<p>html</p>',
                'thumbnail_width': 612,
                'height': None,
                'width': 658,
                'thumbnail_url': '',
                'author_name': 'test',
                'author_id': 2091,
                'thumbnail_height': 612,
                'type': 'rich',
                'provider_name': 'Instagram',
                'author_url': 'https://instagram.com/test'
            }
        )
        self.assertTrue(form.is_valid())

        form = InstagramEmbedAdminForm(
            {
                'parent_id': self.page_1.id,
                'sort_order': 4,
                'parent_type': ContentType.objects.get_for_model(type(self.page_1)).id,
                'url': 'https://test.com/p/5O26siFtv8/',
            }
        )
        form.instance.fetch_instagram_data = Mock(
            return_value='The page is not available'
        )
        self.assertFalse(form.is_valid())
        self.assertEqual(len(form.errors.keys()), 2)
        expected_keys = ['url', '__all__']
        for key in expected_keys:
            self.assertIn(key, form.errors.keys())
        self.assertEqual(form.errors['url'][0], 'Please provide a valid instagram link.')
        form.instance.fetch_instagram_data = initial_fetch_instagram_data

        # Test valid and invalid Instagram URLs
        for valid_url in [
            'http://instagram.com/p/5O26siFtv8/',
            'https://instagram.com/p/5O26siFtv8/',
            'http://www.instagram.com/p/5O26siFtv8/',
            'https://www.instagram.com/p/5O26siFtv8/',
            'http://instagr.am/p/5O26siFtv8/',
            'https://instagr.am/p/5O26siFtv8',
            'http://www.instagr.am/p/5O26siFtv8/',
            'https://www.instagr.am/p/5O26siFtv8',
        ]:
            form = InstagramEmbedAdminForm(
                {
                    'parent_id': self.page_1.id,
                    'sort_order': 4,
                    'parent_type': ContentType.objects.get_for_model(type(self.page_1)).id,
                    'url': valid_url,
                }
            )
            self.assertTrue(form.is_valid())

        for invalid_url in [
            'http://test.com/p/5O26siFtv8/',
            'https://instagrammy.com/p/5O26siFtv8/',
            'http://www2.instagram.com/p/5O26siFtv8/',
            'https://www.instagram.com/x/5O26siFtv8/',
            'http://instagr.am/p/',
        ]:
            form = InstagramEmbedAdminForm(
                {
                    'parent_id': self.page_1.id,
                    'sort_order': 4,
                    'parent_type': ContentType.objects.get_for_model(type(self.page_1)).id,
                    'url': invalid_url,
                }
            )
            self.assertFalse(form.is_valid())
            self.assertEqual(form.errors['url'][0], 'Please provide a valid instagram link.')
