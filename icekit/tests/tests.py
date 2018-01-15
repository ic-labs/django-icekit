"""
Tests for ``icekit`` app.
"""
import os

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html
from unittest import skip

from django.apps import apps
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password
from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.core import exceptions
from django.core.urlresolvers import reverse
from django.utils import six
from django_dynamic_fixture import G
from django_webtest import WebTest
from fluent_contents.models import Placeholder
from fluent_contents.plugins.rawhtml.models import RawHtmlItem
from fluent_pages.models import PageLayout
from fluent_pages.pagetypes.fluentpage.models import FluentPage
from forms_builder.forms.models import Form

from icekit.admin_tools.forms import PasswordResetForm
from icekit.mixins import LayoutFieldMixin
from icekit.page_types.layout_page.models import LayoutPage
from icekit.plugins import descriptors
from icekit.plugins.faq.models import FAQItem
from icekit.plugins.horizontal_rule.models import HorizontalRuleItem
from icekit.plugins.instagram_embed.models import InstagramEmbedItem
from icekit.plugins.map.models import MapItem
from icekit.plugins.quote.models import QuoteItem
from icekit.plugins.reusable_form.models import FormItem
from icekit.plugins.slideshow.models import SlideShow, SlideShowItem
from icekit.plugins.twitter_embed.forms import TwitterEmbedAdminForm
from icekit.plugins.twitter_embed.models import TwitterEmbedItem
from icekit.response_pages.models import ResponsePage
from mock import patch, Mock

from icekit.utils import fluent_contents, implementation
from icekit.admin_tools import mixins

from icekit import models, validators
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
            six.next(PasswordResetForm().get_users(self.user_1.email)),
            self.user_1
        )
        with self.assertRaises(StopIteration):
            six.next(PasswordResetForm().get_users(self.user_2.email))

        with self.assertRaises(StopIteration):
            six.next(PasswordResetForm().get_users(self.user_3.email))

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


class LayoutTest(WebTest):

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
            _embed_code='<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3312.0476344648832!2d151.'
                        '19845715159963!3d-33.88842702741586!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x6b12'
                        'b1d842ee9aa9%3A0xb0a19ac433ef0be8!2sThe+Interaction+Consortium!5e0!3m2!1sen!2sau!4v149620126'
                        '4670" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>'
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
            self.reusable_form_1, self.map_1, self.horizontal_rule_1,
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
        article_listing = test_models.ArticleListing.objects.create(
            title="Article listing",
            author=self.user_1,
        )

        article_1 = test_models.Article.objects.create(
            title='Test Article',
            parent=article_listing,
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
            # ('icekit_plugins_image_image', self.image_1),
            ('fluent_pages_pagelayout', self.page_layout_1),
            ('icekit_layout', self.layout_1),
            ('icekit_mediacategory', self.media_category_1),
            ('response_pages_responsepage', self.response_page_1),
            ('fluent_pages_page', self.layoutpage_1),
        )
        for admin_app, obj in admin_app_list:
            response = self.app.get(
                reverse('admin:%s_changelist' % admin_app),
                user=self.super_user_1)
            self.assertEqual(response.status_code, 200)
            response = self.app.get(
                reverse('admin:%s_add' % admin_app),
                user=self.super_user_1)
            self.assertEqual(response.status_code, 200)
            response = self.app.get(
                reverse('admin:%s_history' % admin_app, args=(obj.id, )),
                user=self.super_user_1)
            self.assertEqual(response.status_code, 200)
            response = self.app.get(
                reverse('admin:%s_delete' % admin_app, args=(obj.id, )),
                user=self.super_user_1)
            self.assertEqual(response.status_code, 200)
            response = self.app.get(
                reverse('admin:%s_change' % admin_app, args=(obj.id, )),
                user=self.super_user_1)
            self.assertEqual(response.status_code, 200)

    # Test workaround applied for django-polymorphic 1.0+ per #31
    def test_can_save_polymorphic_page_in_admin(self):
        response = self.app.get(
            reverse('admin:fluent_pages_page_change',
                    args=(self.layoutpage_1.pk,)),
            user=self.super_user_1)
        # Hit 'Save' in form -- does nothing really, but will fail with
        # `ParentAdminNotRegistered` if polymorphic issue #31 is present.
        response.forms[0].submit()

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

