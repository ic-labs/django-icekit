from mock import patch, Mock

from django.apps import apps
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Permission
from django.core.urlresolvers import reverse
from django.http import HttpResponse
from django.test import TestCase

from django_webtest import WebTest
from django_dynamic_fixture import G

from .utils import ClientError, parse_dimensions_string, \
    parse_region, parse_size


User = get_user_model()
Image = apps.get_model('icekit_plugins_image.Image')


class TestImageApiUtils(TestCase):

    def test_parse_dimensions_string(self):
        self.assertEqual(
            (0, 0, 1, 1), parse_dimensions_string('0,0,1,1'))
        self.assertEqual(
            (0.1, 0.1, 0.1, 0.1),
            parse_dimensions_string('0.1,0.1,0.1,0.1', permit_floats=True))
        # Must use `permit_floats=True` for float values
        self.assertRaises(
            ClientError,
            parse_dimensions_string,
            '0.1,0,1,1')
        # Wrong number of elements
        self.assertRaises(
            ClientError,
            parse_dimensions_string,
            '0,1,1')
        self.assertRaises(
            ClientError,
            parse_dimensions_string,
            '0,0,0,1,1')
        # Negative numbers not permitted
        self.assertRaises(
            ClientError,
            parse_dimensions_string,
            '-1,0,1,1')
        # Elements must be numerical
        self.assertRaises(
            ClientError,
            parse_dimensions_string,
            'a,0,1,1')

    def test_parse_region(self):
        # Region: full
        self.assertEqual(
            (0, 0, 300, 200),
            parse_region('full', 300, 200))
        # Region: square
        self.assertEqual(
            (50, 0, 200, 200),
            parse_region('square', 300, 200))
        self.assertEqual(
            (0, 25, 200, 200),
            parse_region('square', 200, 250))
        # Region: x,y,width,height pixels
        self.assertEqual(
            (0, 25, 100, 200),
            parse_region('0,25,100,200', 200, 250))
        self.assertEqual(
            (0, 25, 200, 175),  # Don't extend crop beyond image height
            parse_region('0,25,200,200', 200, 200))
        self.assertEqual(
            (100, 0, 100, 200),  # Don't extend crop beyond image width
            parse_region('100,0,200,200', 200, 250))
        # Region: x,y,width,height percentages
        self.assertEqual(
            (50, 25, 375, 100),
            parse_region('pct:10,12.5,75,50', 500, 200))
        self.assertEqual(
            (375, 0, 125, 100),  # Don't extend crop beyond image width
            parse_region('pct:75,0,50,50', 500, 200))
        self.assertEqual(
            (0, 0, 500, 200),  # Don't extend crop beyond image height
            parse_region('pct:0,0,100,200', 500, 200))

    def test_parse_size(self):
        # Size: full/max
        self.assertEqual(
            (100, 200), parse_size('full', 100, 200))
        self.assertEqual(
            (200, 100), parse_size('max', 200, 100))
        # Size: pct
        self.assertEqual(
            (100, 200), parse_size('pct:100', 100, 200))
        self.assertEqual(
            (50, 100), parse_size('pct:50', 100, 200))
        # Size: w,h
        self.assertEqual(
            (25, 75), parse_size('25,75', 100, 200))
        # Size: w, (maintain aspect ratio)
        self.assertEqual(
            (50, 100), parse_size('50,', 100, 200))
        self.assertEqual(
            # Can scale beyond original image size
            (125, 250), parse_size('125,', 100, 200))
        # Size: ,h (maintain aspect ratio)
        self.assertEqual(
            (50, 100), parse_size(',100', 100, 200))
        self.assertEqual(
            # Can scale beyond original image size
            (125, 250), parse_size(',250', 100, 200))
        # Size: !w,h (best-fit)
        self.assertEqual(
            # Width is best fit
            (80, 160), parse_size('!80,200', 100, 200))
        self.assertEqual(
            # Width is best fit
            (80, 160), parse_size('!80,160', 100, 200))
        self.assertEqual(
            # Height is best fit
            (75, 150), parse_size('!80,150', 100, 200))
        self.assertEqual(
            # Height is best fit, can scale beyond original image size
            (250, 250), parse_size('!400,250', 200, 200))


class TestImageAPIViews(WebTest):

    def setUp(self):
        self.superuser = G(
            User,
            is_active=True,
            is_superuser=True,
        )
        self.image = G(
            Image,
            width=200,
            height=300,
        )
        # Set up mocks used by default
        patcher = patch(
            'icekit.plugins.iiif.views.FileResponse')
        self.FileResponse = patcher.start()
        self.addCleanup(patcher.stop)

        patcher = patch(
            'icekit.plugins.iiif.views.get_thumbnailer')
        self.get_thumbnailer = patcher.start()
        self.addCleanup(patcher.stop)

        patcher = patch(
            'icekit.plugins.iiif.views.open', return_value='open_mocked')
        self.open = patcher.start()
        self.addCleanup(patcher.stop)

        self.thumbnailer = Mock()
        self.get_thumbnailer.return_value = self.thumbnailer

        self.FileResponse.return_value = HttpResponse('mocked')

    def test_iff_image_api_info(self):
        path = reverse('iiif_image_api_info', args=[self.image.pk])
        response = self.app.get(path, user=self.superuser)
        expected = {
            "@context": "http://iiif.io/api/image/2/context.json",
            "@id": path,
            "protocol": "http://iiif.io/api/image",
            "width": self.image.width,
            "height": self.image.height,
        }
        self.assertEqual(expected, response.json)

    def test_iiif_image_api_basics(self):
        # Not a privileged user
        user = G(User)
        response = self.app.get(
            reverse('iiif_image_api',
                    args=[0, 'full', 'max', '0', 'default', 'jpg']),
            user=user,
            expect_errors=True,
        )
        self.assertEqual(302, response.status_code)
        self.assertEqual(
            'http://localhost:80/login/?next=/iiif/0/full/max/0/default.jpg',
            response.headers['Location'])
        # Now is a privileged user
        user.user_permissions.add(
            Permission.objects.get(codename='can_use_iiif_image_api'))
        response = self.app.get(
            reverse('iiif_image_api',
                    args=[0, 'full', 'max', '0', 'default', 'jpg']),
            user=user,
        )

        # Invalid image identifier
        response = self.app.get(
            reverse('iiif_image_api',
                    args=[0, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(404, response.status_code)

        # Correct use
        response = self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        self.FileResponse.assert_called_with(
                'open_mocked', content_type='image/jpg')

    def test_iiif_image_api_region(self):
        # Region: full
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        # Region: square, 200 x 300 image
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'square', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 50),  # NOTE: Auto-cropped to center square in image
            'size': (self.image.width, self.image.width),  # NOTE: width is smallest edge
        })
        # Region: x,y,w,h
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, '20,30,50,90', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (20, 30),
            'size': (50, 90),
        })
        # Region: x,y,w,h (crop isn't permitted to exceed original image)
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, '100,50,150,300', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (100, 50),
            'size': (100, 250),  # Width & height reduced to fit bounds
        })
        # Region: pct:x,y,w,h
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'pct:10,50,75,50', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (20, 150),
            'size': (150, 150),  # Width & height reduced to fit bounds
        })

    def test_iiif_image_api_size(self):
        # Size: max
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        # Size: full
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'full', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        # Size: pct
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'pct:50', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width / 2, self.image.height / 2),
        })
        # Size: w,h
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', '100,150', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (100, 150),
        })
        # Size: w, (maintain aspect ratio)
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', '150,', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (150, 225),
        })
        # Size: ,h (maintain aspect ratio, scale beyond original image size)
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', ',600', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (400, 600),
        })
        # Size: !w,h (best-fit)
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', '!150,250', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (150, 225),  # Width is best fit
        })
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', '!300,240', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (160, 240),  # Height is best fit
        })

    def test_iiif_image_api_rotation(self):
        # Rotation: 0
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        # Rotation: 360 (converted to 0 since % 360)
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '360', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        # Rotation: invalid value
        response = self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', 'x', 'default', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(400, response.status_code)
        # Rotation other than 0 or 360 not yet supported
        response = self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '90', 'default', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(501, response.status_code)
        self.assertEqual(
            "Image API rotation parameters other than (0,) degrees are not"
            " yet supported: 90",
            response.content)

    def test_iiif_image_api_quality(self):
        # Quality: default
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        # Quality: color
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'color', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
        })
        # Quality: gray
        self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'gray', 'jpg']),
            user=self.superuser,
        )
        self.thumbnailer.get_thumbnail.assert_called_with({
            'crop': (0, 0),
            'size': (self.image.width, self.image.height),
            'bw': True,  # NOTE: Black-and-white filter added
        })
        # Quality: bitonal (not yet supported)
        response = self.app.get(
            reverse('iiif_image_api',
                    args=[self.image.pk, 'full', 'max', '0', 'bitonal', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(501, response.status_code)
        self.assertEqual(
            "Image API quality parameters other than ('default', 'color',"
            " 'gray') are not yet supported: bitonal",
            response.content)
