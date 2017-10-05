import json
import unittest

from django.conf import settings
from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model
from django.core import exceptions
from django.core.urlresolvers import reverse

from django_dynamic_fixture import G
from django_webtest import WebTest
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents

from . import models

User = get_user_model()


class LocationModelTests(unittest.TestCase):

    def setUp(self):
        self.location = models.Location.objects.create(
            title='Test Location',
            slug='test-location',
            map_description='Location for testing',
            map_center_description='Level 5, 48 Chippen St, Chippendale, NSW',
        )

    def tearDown(self):
        models.Location.objects.all().delete()

    def test_clean(self):
        # Map center is required
        with self.assertRaises(exceptions.ValidationError):
            models.Location.objects.create(
                title='Test Location 1',
                slug='test-location-1',
            ).clean()
        # Can create location with map center
        models.Location.objects.create(
            title='Test Location 2',
            slug='test-location-2',
            map_center_description='somewhere',
        ).clean()
        # Can create location with lat/long center
        models.Location.objects.create(
            title='Test Location 3',
            slug='test-location-3',
            map_center_lat='-33.85',
            map_center_long='151.17',
        ).clean()
        # Cannot create location with center description and lat/long values
        with self.assertRaises(exceptions.ValidationError):
            models.Location.objects.create(
                title='Test Location 1',
                slug='test-location-1',
                map_center_description='somewhere',
                map_center_lat='-33.85',
            ).clean()
        with self.assertRaises(exceptions.ValidationError):
            models.Location.objects.create(
                title='Test Location 1',
                slug='test-location-1',
                map_center_description='somewhere',
                map_center_long='-33.85',
            ).clean()
        # Must include both lat and long fields if either are set
        with self.assertRaises(exceptions.ValidationError):
            models.Location.objects.create(
                title='Test Location 1',
                slug='test-location-1',
                map_center_lat='-33.85',
            ).clean()
        with self.assertRaises(exceptions.ValidationError):
            models.Location.objects.create(
                title='Test Location 1',
                slug='test-location-1',
                map_center_long='-33.85',
            ).clean()

    def test_location_has_absolute_url(self):
        self.assertEqual(
            '/location/test-location/',
            self.location.get_absolute_url())

    def test_render_map(self):
        self.assertEquals(
            '<div id="{container_id}" class="google-map"></div>'
            '<script>'
            '    gkGoogleMaps = window.gkGoogleMaps || [];'
            '    gkGoogleMaps.push({data});'
            '</script>'.format(
                container_id=self.location.get_map_element_id(),
                data=json.dumps(self.location.get_map_data()),
            ),
            self.location.render_map())

    def test_get_map_data(self):
        self.assertEquals(
            {
                'containerSelector': '#' + self.location.get_map_element_id(),
                'center': self.location.map_center_description,
                'marker': self.location.map_marker_description or self.location.map_center_description,
                'zoom': self.location.map_zoom,
                'href': self.location.get_map_href(),
                'key': getattr(settings, 'GOOGLE_MAPS_API_KEY', ''),
                'description': [
                    line for line in self.location.map_description.splitlines()
                    if line
                ],
            },
            self.location.get_map_data()
        )

    def test_get_map_href(self):
        # Location has map center description, no map marker
        self.assertEqual(
            '//maps.google.com/maps?'
            'q=Level+5%2C+48+Chippen+St%2C+Chippendale%2C+NSW',
            self.location.get_map_href())
        # Location with map center lat/long
        self.location.map_center_description = ''
        self.location.map_center_lat = '100.1234'
        self.location.map_center_long = '100.2345'
        self.location.save()
        self.assertEqual(
            '//maps.google.com/maps?ll=100.1234%2C100.2345',
            self.location.get_map_href())

    def test_get_map_element_id(self):
        self.assertEqual(
            'google-map-%d' % id(self.location),
            self.location.get_map_element_id())


class LocationViewsTests(WebTest):

    def setUp(self):
        self.location = models.Location.objects.create(
            title='Test Location',
            slug='test-location',
            map_description='Location for testing',
            map_center_description='Level 5, 48 Chippen St, Chippendale, NSW',
        )

    def test_list_view(self):
        listing_url = reverse('icekit_plugins_location_index')
        # Location not yet published, does not appear in listing
        response = self.app.get(listing_url)
        response.mustcontain(no=[
            self.location.get_absolute_url(),
            self.location.title
        ])
        # Published Location does appear in listing
        self.location.publish()
        response = self.app.get(listing_url)
        response.mustcontain(
            self.location.get_absolute_url(),
            self.location.title
        )

    def test_detail_view(self):
        # Location not yet published, detail page is not available
        response = self.app.get(
            self.location.get_absolute_url(),
            expect_errors=True)
        self.assertEqual(404, response.status_code)
        # Published Location page is available
        self.location.publish()
        response = self.app.get(
            self.location.get_published().get_absolute_url())
        response.mustcontain(
            self.location.title
        )


class LocationItemTests(WebTest):

    def setUp(self):
        self.location = models.Location.objects.create(
            title='Test Location',
            slug='test-location',
            map_description='Location for testing',
            map_center_description='Level 5, 48 Chippen St, Chippendale, NSW',
        )

        self.layout = G(
            Layout,
            template_name='icekit/layouts/default.html',
        )
        self.layout.content_types.add(
            ContentType.objects.get_for_model(LayoutPage))
        self.layout.save()
        self.staff_user = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.page = LayoutPage()
        self.page.title = 'Test Page'
        self.page.slug = 'test-page'
        self.page.parent_site = Site.objects.first()
        self.page.layout = self.layout
        self.page.author = self.staff_user
        self.page.save()

        self.location_item = fluent_contents.create_content_instance(
            models.LocationItem,
            self.page,
            location=self.location,
        )

        self.page.publish()

    def test_unpublished_location_does_not_render(self):
        response = self.app.get(self.page.get_published().get_absolute_url())
        # Must *not* contain, hence `no` kwarg
        response.mustcontain(no=[
            self.location.get_absolute_url(),
            self.location.title
        ])

    def test_published_location_renders(self):
        self.location.publish()
        response = self.app.get(self.page.get_published().get_absolute_url())
        response.mustcontain(
            self.location.get_absolute_url(),
            self.location.title,
        )
