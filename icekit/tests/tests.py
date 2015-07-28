"""
Tests for ``icekit`` app.
"""

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html
from django.apps import apps
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password
from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.core import exceptions
from django.core.urlresolvers import reverse
from django_dynamic_fixture import G
from django_webtest import WebTest
from fluent_contents.models import Placeholder
from fluent_pages.models import PageLayout
from fluent_pages.pagetypes.fluentpage.models import FluentPage
from icekit.plugins.faq.models import FAQItem
from icekit.plugins.image.models import ImageItem, Image
from icekit.plugins.instagram_embed.models import InstagramEmbedItem
from icekit.plugins.quote.models import QuoteItem
from icekit.plugins.reusable_quote.models import Quote, ReusableQuoteItem
from icekit.plugins.slideshow.models import SlideShow, SlideShowItem
from icekit.plugins.twitter_embed.models import TwitterEmbedItem
from icekit.response_pages.models import ResponsePage

from icekit.utils import fluent_contents, implementation
from icekit.utils.admin import mixins

from icekit import admin_forms, models, validators
from icekit.tests import models as test_models

# Conditional imports
if apps.is_installed('icekit.plugins.brightcove'):
    from django_brightcove.models import BrightcoveItems
    from icekit.plugins.brightcove.models import BrightcoveItem


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
            admin_forms.PasswordResetForm().get_users(self.user_1.email).next(),
            self.user_1
        )
        with self.assertRaises(StopIteration):
            admin_forms.PasswordResetForm().get_users(self.user_2.email).next()

        with self.assertRaises(StopIteration):
            admin_forms.PasswordResetForm().get_users(self.user_3.email).next()


class Models(WebTest):
    def setUp(self):
        self.site = G(Site)
        self.user_1 = G(User)
        if apps.is_installed('icekit.plugins.brightcove'):
            self.brightcove_video_1 = G(BrightcoveItems)
        self.image_1 = G(Image)
        self.page_layout_1 = G(PageLayout)
        self.layout_1 = G(
            models.Layout,
            template_name='icekit/layouts/default.html',
        )
        self.layout_1.content_types.add(ContentType.objects.get_for_model(FluentPage))
        self.quote_1 = G(Quote)
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
        self.reusable_quote_item_1 = fluent_contents.create_content_instance(
            ReusableQuoteItem,
            self.page_1,
            quote=self.quote_1,
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
            self.image_item_1, self.faq_item_1, self.quote_item_1, self.reusable_quote_item_1,
            self.slide_show_item_1, self.twitter_response_1, self.instagram_embed_1,
        ]
        if apps.is_installed('icekit.plugins.brightcove'):
            anticipated_content_instances.append(self.brightcove_item_1)

        self.assertEqual(len(anticipated_content_instances), content_instances.count())
        for obj in anticipated_content_instances:
            self.assertIn(obj, content_instances)

    def test_str_functions(self):
        self.assertEqual(str(self.reusable_quote_item_1), str(self.quote_1))
        self.assertEqual(str(self.image_item_1), str(self.image_1))
        self.assertEqual(str(self.quote_item_1), self.quote_item_1.quote)
        self.assertEqual(str(self.slide_show_item_1), str(self.slide_show_1))

        if apps.is_installed('icekit.plugins.brightcove'):
            self.assertEqual(str(self.brightcove_item_1), str(self.brightcove_video_1))

        self.assertEqual(str(self.faq_item_1), self.faq_item_1.question)

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
        self.quote_1 = G(Quote)
        self.media_category_1 = G(models.MediaCategory)
        self.layout_1 = G(models.Layout)
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

    def test_admin_pages(self):
        response = self.app.get(reverse('admin:index'), user=self.super_user_1)
        self.assertEqual(response.status_code, 200)
        admin_app_list = (
            ('image_image', self.image_1),
            ('reusable_quote_quote', self.quote_1),
            ('fluent_pages_pagelayout', self.page_layout_1),
            ('icekit_layout', self.layout_1),
            ('icekit_mediacategory', self.media_category_1),
            ('response_pages_responsepage', self.response_page_1),
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
