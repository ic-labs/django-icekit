from mock import patch

from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model
from django.core import exceptions

from django_dynamic_fixture import G
from django_webtest import WebTest
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents

from . import models

User = get_user_model()


class MapItemTestCase(WebTest):
    def setUp(self):
        self.share_url = 'https://www.google.com.au/maps/place/Chippen+St,' \
            '+Chippendale+NSW+2008/@-33.8877043,151.2005881,17z/data=!4m' \
            '7!1m4!3m3!1s0x6b12b1d86f0291cf:0x74b2d18fb93fed35!2sChippen' \
            '+St,+Chippendale+NSW+2008!3b1!3m1!1s0x6b12b1d86f0291cf:0x74' \
            'b2d18fb93fed35'
        self.layout_1 = G(
            Layout,
            template_name='layout_page/layoutpage/layouts/default.html',
        )
        self.layout_1.content_types.add(
            ContentType.objects.get_for_model(LayoutPage))
        self.layout_1.save()
        self.staff_1 = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.page_1 = LayoutPage()
        self.page_1.title = 'Test Page'
        self.page_1.slug = 'test-page'
        self.page_1.parent_site = Site.objects.first()
        self.page_1.layout = self.layout_1
        self.page_1.author = self.staff_1
        self.page_1.status = 'p'  # Publish the page
        self.page_1.save()
        self.map_1 = fluent_contents.create_content_instance(
            models.MapItem,
            self.page_1,
            share_url=self.share_url
        )
        self.map_1.parse_share_url()

        self.map_item = models.MapItem(
            parent_type=ContentType.objects.get_for_model(type(self.page_1)),
            parent_id=self.page_1.id,
            placeholder=self.page_1.get_placeholder_by_slot('main')[0],
            share_url=self.share_url,
        )

        self.page_1.publish()

    def test_regex_finds_values(self):
        response = self.app.get(self.page_1.get_published().get_absolute_url())
        response.mustcontain('Chippen+St,+Chippendale')
        response.mustcontain('-33.8877043,151.2005881,17z')

    def test_map_renders(self):
        response = self.app.get(self.page_1.get_published().get_absolute_url())
        response.mustcontain('<iframe')

    def test_clean(self):
        self.assertEqual(self.map_item.loc, '')
        self.assertEqual(self.map_item.place_name, 'Unknown')
        self.map_item.clean()
        self.assertEqual(self.map_item.loc, '-33.8877043,151.2005881,17z')
        self.assertEqual(self.map_item.place_name, 'Chippen+St,+Chippendale+NSW+2008')
        self.map_item.share_url = 'this really should not work'
        with self.assertRaises(exceptions.ValidationError):
            self.map_item.clean()

    def test_str(self):
        self.assertEqual(str(self.map_1), '%s @%s' % (self.map_1.place_name, self.map_1.loc))
        self.map_item.place_name = 'Unknown'
        self.assertEqual(
            str(self.map_item),
            '%s @%s' % (self.map_item.place_name, self.map_item.loc)
        )

    def test_google_map_share_url_parsing(self):
        map_detailed_share_url = fluent_contents.create_content_instance(
            models.MapItem,
            self.page_1,
            share_url='https://www.google.com.au/maps/place/The+Interaction+Consortium/'
                      '@-33.8884315,151.2006512,17z/data=!3m1!4b1!4m2!3m1!1s0x6b12b1d842ee9aa9:'
                      '0xb0a19ac433ef0be8'
        )
        self.assertEqual('The+Interaction+Consortium',
                         map_detailed_share_url.place_name)
        self.assertEqual('-33.8884315,151.2006512,17z',
                         map_detailed_share_url.loc)

        map_embed_url = fluent_contents.create_content_instance(
            models.MapItem,
            self.page_1,
            share_url='https://www.google.com/maps/d/embed?mid=zLFp8zmG_u7Y.kWM6FxvhXeUw',
        )
        self.assertEqual('Unknown',
                         map_embed_url.place_name)
        self.assertEqual('',
                         map_embed_url.loc)

        # Edit URL converted to embed version
        map_viewer_share_url = fluent_contents.create_content_instance(
            models.MapItem,
            self.page_1,
            share_url='https://www.google.com/maps/d/edit?mid=zLFp8zmG_u7Y.kWM6FxvhXeUw&usp=sharing',
        )
        self.assertEqual(
            'https://www.google.com/maps/d/embed?mid=zLFp8zmG_u7Y.kWM6FxvhXeUw&usp=sharing',
            map_viewer_share_url.share_url)
        self.assertEqual('Unknown',
                         map_viewer_share_url.place_name)
        self.assertEqual('',
                         map_viewer_share_url.loc)

        # Viewer URL converted to embed version
        map_viewer_share_url = fluent_contents.create_content_instance(
            models.MapItem,
            self.page_1,
            share_url='https://www.google.com/maps/d/u/0/viewer?mid=zLFp8zmG_u7Y.kWM6FxvhXeUw',
        )
        self.assertEqual(
            'https://www.google.com/maps/d/embed?mid=zLFp8zmG_u7Y.kWM6FxvhXeUw',
            map_viewer_share_url.share_url)
        self.assertEqual('Unknown',
                         map_viewer_share_url.place_name)
        self.assertEqual('',
                         map_viewer_share_url.loc)

        # Shortened URL converted to full version
        with patch('icekit.plugins.map.abstract_models.urlopen') as mock_urlopen:
            # Fake URL lookup and redirect to get un-shortened URL
            mock_urlopen.return_value.url = (
                'https://www.google.com.au/maps/place/The+Interaction+Consortium/'
                '@-33.8884315,151.2006512,17z/data=!3m1!4b1!4m2!3m1!1s0x6b12b1d842ee9aa9:'
                '0xb0a19ac433ef0be8'
            )

            map_shortened_share_url = fluent_contents.create_content_instance(
                models.MapItem,
                self.page_1,
                share_url='https://goo.gl/maps/P4Mlm',
            )
        self.assertEqual(
            'https://www.google.com.au/maps/place/The+Interaction+Consortium/'
            '@-33.8884315,151.2006512,17z/data=!3m1!4b1!4m2!3m1!1s0x6b12b1d842ee9aa9:'
            '0xb0a19ac433ef0be8',
            map_shortened_share_url.share_url)
        self.assertEqual('The+Interaction+Consortium',
                         map_detailed_share_url.place_name)
        self.assertEqual('-33.8884315,151.2006512,17z',
                         map_detailed_share_url.loc)

        # Unrecognised share URL rejected
        with self.assertRaises(exceptions.ValidationError):
            fluent_contents.create_content_instance(
                models.MapItem,
                self.page_1,
                share_url='https://www.google.com/',
            )
