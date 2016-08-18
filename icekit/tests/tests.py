"""
Tests for ``icekit`` app.
"""
import os

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html
from django.apps import apps
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password
from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.core import exceptions
from django.core.urlresolvers import reverse
from django.test import TestCase
from django.utils import six
from django_dynamic_fixture import G
from django_webtest import WebTest
from fluent_contents.models import Placeholder
from fluent_contents.plugins.rawhtml.models import RawHtmlItem
from fluent_pages.models import PageLayout
from fluent_pages.pagetypes.fluentpage.models import FluentPage
from forms_builder.forms.models import Form
from icekit.abstract_models import LayoutFieldMixin
from icekit.page_types.layout_page.models import LayoutPage
from icekit.page_types import utils as page_types_utils
from icekit.plugins import descriptors
from icekit.plugins.faq.models import FAQItem
from icekit.plugins.horizontal_rule.models import HorizontalRuleItem
from icekit.plugins.instagram_embed.models import InstagramEmbedItem
from icekit.plugins.map.models import MapItem
from icekit.plugins.map_with_text.models import MapWithTextItem
from icekit.plugins.quote.models import QuoteItem
from icekit.plugins.reusable_form.models import FormItem
from icekit.plugins.slideshow.models import SlideShow, SlideShowItem
from icekit.plugins.twitter_embed.forms import TwitterEmbedAdminForm
from icekit.plugins.twitter_embed.models import TwitterEmbedItem
from icekit.response_pages.models import ResponsePage
from mock import patch, Mock

from icekit.utils import fluent_contents, implementation
from icekit.utils.admin import mixins
from icekit.utils.pagination import describe_page_numbers

from icekit import admin_forms, models, validators
from icekit.tests import models as test_models

# Conditional imports
if apps.is_installed('icekit.plugins.brightcove'):
    from django_brightcove.models import BrightcoveItems
    from icekit.plugins.brightcove.models import BrightcoveItem

Image = apps.get_model('icekit_plugins_image.Image')
ImageItem = apps.get_model('icekit_plugins_image.ImageItem')

User = get_user_model()


class Forms(WebTest):
    def setUp(self):
        self.user_1 = G(
            User,
            is_staff=True,
            is_active=True,
        )
        self.user_1.password = make_password('test_password123')
        self.user_1.save()
        self.user_2 = G(
            User,
            is_active=True,
        )
        self.user_2.password = make_password('test_password123')
        self.user_2.save()
        self.user_3 = G(
            User,
            is_active=False,
            is_staff=True,
        )
        self.user_3.password = make_password('test_password123')
        self.user_3.save()

    def test_password_reset_form(self):
        self.assertEqual(
            six.next(admin_forms.PasswordResetForm().get_users(self.user_1.email)),
            self.user_1
        )
        with self.assertRaises(StopIteration):
            six.next(admin_forms.PasswordResetForm().get_users(self.user_2.email))

        with self.assertRaises(StopIteration):
            six.next(admin_forms.PasswordResetForm().get_users(self.user_3.email))

    def test_twitter_embed_admin_form(self):
        twitter_url = 'https://twitter.com/Interior/status/463440424141459456'
        teaf = TwitterEmbedAdminForm({'twitter_url': 'http://test.com/', })
        initial_fetch_twitter_data = teaf.instance.fetch_twitter_data
        teaf.instance.fetch_twitter_data = Mock(
            return_value={
                'errors': [{
                    'message': 'Please provide a valid twitter link.'
                }, ]
            }
        )

        teaf.full_clean()
        teaf.instance.fetch_twitter_data = initial_fetch_twitter_data
        self.assertEqual(teaf.errors['twitter_url'], ['Please provide a valid twitter link.'])
        teaf = TwitterEmbedAdminForm({
            'twitter_url': twitter_url
        })
        initial_fetch_twitter_data = teaf.instance.fetch_twitter_data
        teaf.instance.fetch_twitter_data = Mock(
            return_value={
                'url': twitter_url,
                'provider_url': '',
                'cache_age': '',
                'author_name': '',
                'height': '',
                'width': '',
                'provider_name': '',
                'version': '',
                'author_url': '',
                'type': '',
                'html': '<p></p>',
            }
        )
        teaf.full_clean()
        teaf.instance.fetch_twitter_data = initial_fetch_twitter_data
        self.assertEqual(teaf.cleaned_data['twitter_url'], twitter_url)


class Layout(WebTest):

    def test_auto_add(self):
        # No layouts.
        self.assertEqual(models.Layout.objects.count(), 0)
        # Create for existing template.
        layout = models.Layout.auto_add(
            'icekit/layouts/default.html',
            test_models.FooWithLayout,
        )
        # 1 layout.
        self.assertEqual(models.Layout.objects.count(), 1)
        # And has 1 content type.
        self.assertEqual(layout.content_types.count(), 1)
        # And the content type's model name is its title.
        self.assertEqual(layout.title, 'foo with layout')
        # Update and add content types.
        layout = models.Layout.auto_add(
            'icekit/layouts/default.html',
            test_models.FooWithLayout,
            test_models.BarWithLayout,
            test_models.BazWithLayout,
        )
        # Still only 1 layout.
        self.assertEqual(models.Layout.objects.count(), 1)
        # Now with 3 content types.
        self.assertEqual(layout.content_types.count(), 3)
        # And all model names in its title, which has been split and sorted.
        self.assertEqual(
            layout.title,
            'bar with layout, baz with layout, foo with layout',
        )


class Models(WebTest):
    def setUp(self):
        self.site, __ = Site.objects.get_or_create(
            pk=1,
            defaults={'name': 'example.com', 'domain': 'example.com'})
        self.user_1 = G(User)
        self.form_1 = G(Form)
        if apps.is_installed('icekit.plugins.brightcove'):
            self.brightcove_video_1 = G(BrightcoveItems)
        self.image_1 = G(Image)
        self.page_layout_1 = G(PageLayout)
        self.layout_1 = G(
            models.Layout,
            template_name='icekit/layouts/default.html',
        )
        self.layout_1.content_types.add(ContentType.objects.get_for_model(FluentPage))
        self.page_1 = FluentPage.objects.create(
            author=self.user_1,
            title='Test title',
            layout=self.page_layout_1,
        )
        if apps.is_installed('icekit.plugins.brightcove'):
            self.brightcove_item_1 = fluent_contents.create_content_instance(
                BrightcoveItem,
                self.page_1,
                video=self.brightcove_video_1,
            )
        self.image_item_1 = fluent_contents.create_content_instance(
            ImageItem,
            self.page_1,
            image=self.image_1,
        )
        self.faq_item_1 = fluent_contents.create_content_instance(
            FAQItem,
            self.page_1,
            question='test question',
            answer='test answer',
        )
        self.quote_item_1 = fluent_contents.create_content_instance(
            QuoteItem,
            self.page_1,
            quote='test quote',
        )
        self.slide_show_1 = G(SlideShow)
        self.slide_show_item_1 = fluent_contents.create_content_instance(
            SlideShowItem,
            self.page_1,
            slide_show=self.slide_show_1,
        )
        self.twitter_response_1 = fluent_contents.create_content_instance(
            TwitterEmbedItem,
            self.page_1,
            twitter_url='http://twitter.com/asdf/status/sdfsdfsdf'
        )
        self.instagram_embed_1 = fluent_contents.create_content_instance(
            InstagramEmbedItem,
            self.page_1,
            url='http://instagram.com/p/adasdads'
        )
        self.reusable_form_1 = fluent_contents.create_content_instance(
            FormItem,
            self.page_1,
            form=self.form_1,
        )
        self.map_1 = fluent_contents.create_content_instance(
            MapItem,
            self.page_1,
            share_url='https://www.google.com.au/maps/place/The+Interaction+Consortium/'
                      '@-33.8884315,151.2006512,17z/data=!3m1!4b1!4m2!3m1!1s0x6b12b1d842ee9aa9:'
                      '0xb0a19ac433ef0be8'
        )
        self.map_with_text_1 = fluent_contents.create_content_instance(
            MapWithTextItem,
            self.page_1,
            share_url='https://www.google.com.au/maps/place/The+Interaction+Consortium/'
                      '@-33.8884315,151.2006512,17z/data=!3m1!4b1!4m2!3m1!1s0x6b12b1d842ee9aa9:'
                      '0xb0a19ac433ef0be8'
        )
        self.horizontal_rule_1 = fluent_contents.create_content_instance(
            HorizontalRuleItem,
            self.page_1
        )

    def test_BaseModel(self):
        """
        Test that ``modified`` field is updated on save.
        """
        obj = G(test_models.BaseModel)
        modified = obj.modified
        obj.save()
        self.assertNotEqual(obj.modified, modified)

    def test_page_creation(self):
        content_instances = self.page_1.placeholder_set.all()[0].get_content_items()
        anticipated_content_instances = [
            self.image_item_1, self.faq_item_1, self.quote_item_1,
            self.slide_show_item_1, self.twitter_response_1, self.instagram_embed_1,
            self.reusable_form_1, self.map_1, self.map_with_text_1, self.horizontal_rule_1,
        ]
        if apps.is_installed('icekit.plugins.brightcove'):
            anticipated_content_instances.append(self.brightcove_item_1)

        self.assertEqual(len(anticipated_content_instances), content_instances.count())
        for obj in anticipated_content_instances:
            self.assertIn(obj, content_instances)

    def test_str_functions(self):
        self.assertEqual(str(self.image_item_1), str(self.image_1))
        self.assertEqual(str(self.quote_item_1), self.quote_item_1.quote)
        self.assertEqual(str(self.slide_show_item_1), str(self.slide_show_1))

        if apps.is_installed('icekit.plugins.brightcove'):
            self.assertEqual(str(self.brightcove_item_1), str(self.brightcove_video_1))

        self.assertEqual(str(self.faq_item_1), self.faq_item_1.question)
        self.assertEqual(
            str(self.twitter_response_1),
            'Twitter Embed: %s' % self.twitter_response_1.twitter_url
        )
        self.assertEqual(str(self.reusable_form_1), self.reusable_form_1.form.title)

    def test_layout_queryset_for_model(self):
        layouts = models.Layout.objects.for_model(self.page_1)
        anticipated_layouts = [self.layout_1, ]
        self.assertEqual(layouts.count(), len(anticipated_layouts))
        for anticipated_layout in anticipated_layouts:
            self.assertIn(anticipated_layout, layouts)

    def test_layout_get_template(self):
        template = self.layout_1.get_template()
        self.assertEqual(
            template.name if hasattr(template, 'name') else template.template.name,
            'icekit/layouts/default.html'
        )

    def test_twitter_embed_item(self):
        initial_twitter_url = self.twitter_response_1.twitter_url
        self.twitter_response_1.twitter_url = 'https://twitter.com/Interior/status/' \
                                              '463440424141459456'
        self.twitter_response_1.url = ''
        self.assertEqual(self.twitter_response_1.url, '')

        initial_fetch_twitter_data = self.twitter_response_1.fetch_twitter_data
        self.twitter_response_1.fetch_twitter_data = Mock(
            return_value={
                'url': 'https://twitter.com/Interior/statuses/463440424141459456',
                'provider_url': '',
                'cache_age': '',
                'author_name': '',
                'height': '',
                'width': '',
                'provider_name': '',
                'version': '',
                'author_url': '',
                'type': '',
                'html': '<p></p>',
            }
        )

        self.twitter_response_1.clean()
        self.twitter_response_1.fetch_twitter_data = initial_fetch_twitter_data
        self.assertEqual(
            self.twitter_response_1.url,
            'https://twitter.com/Interior/statuses/463440424141459456'
        )
        self.assertEqual(
            self.twitter_response_1.get_default_embed(),
            self.twitter_response_1.html
        )
        self.twitter_response_1.html = ''
        self.assertEqual(
            self.twitter_response_1.get_default_embed(),
            ''
        )
        with self.assertRaises(exceptions.ValidationError):
            self.twitter_response_1.twitter_url = 'https://twitter.com/Interior/status/not-real'
            initial_fetch_twitter_data = self.twitter_response_1.fetch_twitter_data
            self.twitter_response_1.fetch_twitter_data = Mock(
                return_value={
                    'errors': [{
                        'message': 'This did not work.'
                    }, ]
                }
            )

            self.twitter_response_1.clean()
            self.twitter_response_1.fetch_twitter_data = initial_fetch_twitter_data

        with self.assertRaises(exceptions.ValidationError):
            self.twitter_response_1.twitter_url = 'http://test.com/'
            self.twitter_response_1.clean()

        self.twitter_response_1.twitter_url = initial_twitter_url

        with patch.object(TwitterEmbedItem, 'fetch_twitter_data', return_value=''):
            tei = TwitterEmbedItem(twitter_url='http://www.google.com')
            with self.assertRaises(exceptions.ValidationError):
                tei.full_clean()

        with patch('requests.api.request') as mock_get:
            mock_get.status_code = 500

            tei = TwitterEmbedItem(twitter_url='http://www.google.com')
            with self.assertRaises(exceptions.ValidationError):
                tei.full_clean()

    def test_map_with_text_item(self):
        self.assertEqual(
            self.map_with_text_1.get_text(),
            self.map_with_text_1.text
        )

    def test_incorrect_declaration_on_item(self):
        initial_count = FAQItem.objects.count()
        with self.assertRaises(Exception):
            self.faq_item_1 = fluent_contents.create_content_instance(
                FAQItem,
                self.page_1,
                fake='test answer',
            )
        self.assertEqual(FAQItem.objects.count(), initial_count)

    def test_layout_field_mixin(self):
        mixin = LayoutFieldMixin()
        self.assertEqual(mixin.get_layout_template_name(), 'icekit/layouts/fallback_default.html')
        mixin_layout = G(models.Layout)
        mixin.layout = mixin_layout
        self.assertEqual(mixin.get_layout_template_name(), mixin_layout.template_name)
        mixin_layout.delete()

    def test_article_publishing_querysets(self):
        article_1 = test_models.Article.objects.create(
            title='Test Article'
        )
        self.assertIn(article_1, test_models.Article.objects.all())
        self.assertEqual(test_models.Article.objects.count(), 1)
        self.assertEqual(test_models.Article.objects.published().count(), 0)
        self.assertEqual(test_models.Article.objects.draft().count(), 1)


class Views(WebTest):
    def setUp(self):
        self.super_user_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.image_1 = G(Image)
        self.page_layout_1 = G(PageLayout)
        self.media_category_1 = G(models.MediaCategory)
        self.layout_1 = G(
            models.Layout,
            template_name='icekit/layouts/default.html',
        )
        self.response_page_1 = G(
            ResponsePage,
            type='404',
            is_active=True,
        )
        self.response_page_2 = G(
            ResponsePage,
            type='500',
            is_active=True,
        )

        self.placeholder_1 = Placeholder.objects.create_for_object(
            self.response_page_1,
            'response_page'
        )
        self.placeholder_1 = Placeholder.objects.create_for_object(
            self.response_page_2,
            'response_page'
        )

        self.layoutpage_1 = LayoutPage.objects.create(
            author=self.super_user_1,
            title='Test LayoutPage',
            layout=self.layout_1,
        )
        self.content_instance_1 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage_1,
            html='<b>test 1</b>'
        )
        self.content_instance_2 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage_1,
            html='<b>test 2</b>'
        )
        self.content_instance_3 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage_1,
            html='<b>test 3</b>'
        )

    def test_admin_pages(self):
        response = self.app.get(reverse('admin:index'), user=self.super_user_1)
        self.assertEqual(response.status_code, 200)
        admin_app_list = (
            ('icekit_plugins_image_image', self.image_1),
            ('fluent_pages_pagelayout', self.page_layout_1),
            ('icekit_layout', self.layout_1),
            ('icekit_mediacategory', self.media_category_1),
            ('response_pages_responsepage', self.response_page_1),
            ('fluent_pages_page', self.layoutpage_1),
        )
        for admin_app, obj in admin_app_list:
            response = self.app.get(reverse('admin:%s_changelist' % admin_app))
            self.assertEqual(response.status_code, 200)
            response = self.app.get(reverse('admin:%s_add' % admin_app))
            self.assertEqual(response.status_code, 200)
            response = self.app.get(reverse('admin:%s_history' % admin_app, args=(obj.id, )))
            self.assertEqual(response.status_code, 200)
            response = self.app.get(reverse('admin:%s_delete' % admin_app, args=(obj.id, )))
            self.assertEqual(response.status_code, 200)
            response = self.app.get(reverse('admin:%s_change' % admin_app, args=(obj.id, )))
            self.assertEqual(response.status_code, 200)

    def test_index(self):
        response = self.app.get(reverse('icekit_index'))
        response.mustcontain('Hello World')

    def test_response_pages(self):
        response = self.app.get(reverse('404'), expect_errors=404)
        self.assertEqual(response.status_code, 404)
        response.mustcontain(self.response_page_1.title)
        response = self.app.get(reverse('500'), expect_errors=500)
        self.assertEqual(response.status_code, 500)
        response.mustcontain(self.response_page_2.title)

        self.response_page_1.is_active = False
        self.response_page_1.save()
        response = self.app.get(reverse('404'), expect_errors=404)
        response.mustcontain(
            '<h1>Not Found</h1><p>The requested URL /404/ was not found on this server.</p>'
        )
        self.response_page_1.is_active = True
        self.response_page_1.save()

        self.response_page_2.is_active = False
        self.response_page_2.save()
        response = self.app.get(reverse('500'), expect_errors=500)
        response.mustcontain('<h1>Server Error (500)</h1>')
        self.response_page_2.is_active = True
        self.response_page_2.save()

    def test_layoutpage_front_end(self):
        # LayoutPage is unpublished
        response = self.client.get(self.layoutpage_1.get_absolute_url())
        self.assertEqual(response.status_code, 404)
        # LayoutPage is published
        self.layoutpage_1.publish()
        response = self.client.get(self.layoutpage_1.get_absolute_url())
        self.assertEqual(response.status_code, 200)

    def test_page_api(self):
        self.layoutpage_1.publish()
        for j in range(20):
            published_layoutpage = LayoutPage.objects.create(
                author=self.super_user_1,
                title='Test LayoutPage %s' % j,
                layout=self.layout_1,
            )
            published_layoutpage.publish()

            draft_layoutpage = LayoutPage.objects.create(
                author=self.super_user_1,
                title='Draft LayoutPage %s' % j,
                layout=self.layout_1,
            )

        response = self.client.get(reverse('page-list'))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data['results']), 5)
        self.assertEqual(response.data['count'], 21)
        response = self.client.get(reverse('page-detail', args=(self.layoutpage_1.id,)))
        self.assertEqual(response.status_code, 404)
        response = self.client.get(reverse('page-detail', args=(self.layoutpage_1.get_published().id,)))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 6)
        for key in response.data.keys():
            if key is not 'content':
                self.assertEqual(response.data[key],
                                 getattr(self.layoutpage_1.get_published(), key))
        self.assertEqual(len(response.data['content']), 3)
        for number, item in enumerate(response.data['content'], 1):
            self.assertEqual(item['content'], getattr(self, 'content_instance_%s' % number).html)


class TestValidators(WebTest):
    def test_template_name(self):
        self.assertIsNone(validators.template_name('icekit/layouts/default.html'))
        with self.assertRaises(exceptions.ValidationError):
            validators.template_name('ssdf')

    def test_check_settings(self):
        self.assertEqual(implementation.check_settings(['SITE_ID', ]), None)
        with self.assertRaises(NotImplementedError):
            implementation.check_settings(['NO_SUCH_SETTING', ])

    def test_thumbnail_admin_mixin(self):
        class TestThumbnail(object):
            test = 'test-result'
        admin_mixin = mixins.ThumbnailAdminMixin()
        self.assertEqual(admin_mixin.get_thumbnail_source(None), None)
        admin_mixin.thumbnail_field = 'test'
        self.assertEqual(admin_mixin.get_thumbnail_source(TestThumbnail()), 'test-result')
        self.assertEqual(admin_mixin.thumbnail(TestThumbnail()), '')


class TestIceKitTags(WebTest):
    def test_get_slot_contents(self):
        descriptors.contribute_to_class(LayoutPage)
        layout_1 = G(
            models.Layout,
            template_name='icekit/layouts/test_slot_contents.html',
        )
        layout_1.content_types.add(ContentType.objects.get_for_model(LayoutPage))
        layout_1.save()
        staff_1 = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        page_1 = LayoutPage.objects.create(
            title='Test Page',
            slug='test-page',
            parent_site=Site.objects.first(),
            layout=layout_1,
            author=staff_1,
        )

        hr = fluent_contents.create_content_instance(
            HorizontalRuleItem,
            page_1,
            placeholder_name='test-main',
        )
        # Publish the page
        page_1.publish()

        response = self.app.get(page_1.get_published().get_absolute_url())

        response.mustcontain('<div class="filter">Horizontal Rule</div>')
        response.mustcontain('<div class="tag-as"></div>')
        response.mustcontain('<div class="tag-render">Horizontal Rule</div>')
        response.mustcontain('<div class="tag-fake-slot"></div>')
        response.mustcontain('<div class="tag-fake-slot-render">None</div>')
        response.mustcontain('div class="filter-fake-slot">None</div>')


class TestDescribePageNumbers(TestCase):
    def test_join_words(self):
        self.assertEqual(
            describe_page_numbers(1, 500, 10),
            {
                'numbers': [1, 2, 3, 4, None, 48, 49, 50],
                'has_previous': False,
                'has_next': True,
                'previous_page': 0,
                'current_page': 1,
                'next_page': 2,
                'total_count': 500,
                'per_page': 10,
            },
        )

        self.assertEqual(
            describe_page_numbers(10, 500, 10),
            {
                'numbers': [1, 2, 3, None, 7, 8, 9, 10, 11, 12, 13, None, 48, 49, 50],
                'has_previous': True,
                'has_next': True,
                'previous_page': 9,
                'current_page': 10,
                'next_page': 11,
                'total_count': 500,
                'per_page': 10,
            },
        )

        self.assertEqual(
            describe_page_numbers(50, 500, 10),
            {
                'numbers': [1, 2, 3, None, 47, 48, 49, 50],
                'has_previous': True,
                'has_next': False,
                'previous_page': 49,
                'current_page': 50,
                'next_page': 51,
                'total_count': 500,
                'per_page': 10,
            },
        )


class PageTypesUtils(WebTest):

    def test_get_pages_template_dir(self):
        self.assertEqual(
            page_types_utils.get_pages_template_dir('', default_path=''),
            settings.BASE_DIR
        )

        template_dirs = settings.TEMPLATE_DIRS
        settings.TEMPLATE_DIRS = ''

        # A lambda is used to call the function as assertRaises only accepts a callable.
        self.assertRaises(
            exceptions.ImproperlyConfigured,
            lambda: page_types_utils.get_pages_template_dir('', default_path=''),
        )

        settings.TEMPLATE_DIRS = template_dirs

        # A lambda is used to call the function as assertRaises only accepts a callable.
        self.assertRaises(
            exceptions.ImproperlyConfigured,
            lambda: page_types_utils.get_pages_template_dir('', os.path.relpath(os.path.dirname(__file__))),
        )

        # A lambda is used to call the function as assertRaises only accepts a callable.
        self.assertRaises(
            exceptions.ImproperlyConfigured,
            lambda: page_types_utils.get_pages_template_dir('', '/this-most-likely-wont-exist/'),
        )
