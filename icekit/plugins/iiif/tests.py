import time
from mock import patch, Mock, call, ANY
import tempfile

from django.apps import apps
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Permission
from django.core.files.storage import FileSystemStorage
from django.core.urlresolvers import reverse
from django.http import HttpResponse
from django.test import TestCase

from django_webtest import WebTest
from django_dynamic_fixture import G

from .utils import ClientError, parse_dimensions_string, \
    parse_region, parse_size, make_canonical_path


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

    def test_make_canonical_url(self):
        # No image transformation
        self.assertEqual(
            '/iiif/1/full/full/0/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))

        # No-op region change for square image
        self.assertEqual(
            '/iiif/1/full/full/0/default.jpg',
            make_canonical_path(
                1, 800, 800,  # Image identifier and dimensions
                (0, 0, 800, 800),  # Region
                (800, 800),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))
        # Region changed top-left
        self.assertEqual(
            '/iiif/1/0,1,800,599/800,/0/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 1, 800, 599),  # Region
                (800, 600),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))
        # Region changed bottom-right
        self.assertEqual(
            '/iiif/1/0,0,799,600/800,/0/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 799, 600),  # Region
                (800, 600),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))

        # Size changed: same aspect ratio so w, only
        self.assertEqual(
            '/iiif/1/full/400,/0/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (400, 300),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))
        # Size changed: width, aspect ratio changed
        self.assertEqual(
            '/iiif/1/full/750,600/0/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (750, 600),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))
        # Size changed: height, aspect ratio changed
        self.assertEqual(
            '/iiif/1/full/800,900/0/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 900),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))

        # Rotation changed: mirrored
        self.assertEqual(
            '/iiif/1/full/full/!0/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (True, 0),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))
        # Rotation changed: rotated
        self.assertEqual(
            '/iiif/1/full/full/120/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (False, 120),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))
        # Rotation changed: negative rotation
        self.assertEqual(
            '/iiif/1/full/full/-90/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (False, -90),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))
        # Rotation changed: rotated and mirrored
        self.assertEqual(
            '/iiif/1/full/full/!180/default.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (True, 180),  # Rotation
                'default',  # Quality
                'jpg',  # Format
            ))

        # Quality change: color
        self.assertEqual(
            '/iiif/1/full/full/0/color.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (False, 0),  # Rotation
                'color',  # Quality
                'jpg',  # Format
            ))
        # Quality changed: gray
        self.assertEqual(
            '/iiif/1/full/full/0/gray.jpg',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (False, 0),  # Rotation
                'gray',  # Quality
                'jpg',  # Format
            ))

        # Format change: tif
        self.assertEqual(
            '/iiif/1/full/full/0/default.tif',
            make_canonical_path(
                1, 800, 600,  # Image identifier and dimensions
                (0, 0, 800, 600),  # Region
                (800, 600),  # Size
                (False, 0),  # Rotation
                'default',  # Quality
                'tif',  # Format
            ))


class TestImageAPIViews(WebTest):

    def setUp(self):
        # Disable file storage engine for tests
        from icekit.plugins.iiif import views
        views.iiif_storage = None

        self.superuser = G(
            User,
            is_active=True,
            is_superuser=True,
        )
        self.ik_image = G(
            Image,
            width=200,
            height=300,
            credit="IC Arts Collection",
            source="Interaction Consortium",
            license="CC",
        )
        # Set up mocks used by default
        patcher = patch(
            'icekit.plugins.iiif.views.FileResponse')
        self.FileResponse = patcher.start()
        self.addCleanup(patcher.stop)

        self.FileResponse.return_value = HttpResponse('mocked')

    def mock_image(self, width=200, height=300, name='test.jpg', mode='RGB',
                   return_from=None):
        """
        Return a mock to simulate a PIL Image with some default attributes set,
        and optionally hooked up to return from a `_get_image_or_404` mock.
        """
        image = Mock()
        image.configure_mock(**{
            # Set image attributes
            'width': width,
            'height': height,
            'name': name,
            'mode': mode,
        })
        if return_from is not None:
            return_from.return_value = (self.ik_image, image)
        return image

    def test_iiif_image_api_info(self):
        self.maxDiff = None  # Show whole diff on mismatch
        path = reverse('iiif_image_api_info', args=[self.ik_image.pk])
        # Not a privileged user
        user = G(User)
        response = self.app.get(path, user=user, expect_errors=True)
        self.assertEqual(302, response.status_code)
        self.assertTrue(
            response.headers.get('Location', '').endswith(
                '/login/?next=/iiif/%d/info.json' % self.ik_image.pk))
        # Valid response including basic data, attribution, & license
        response = self.app.get(path, user=self.superuser)
        expected = {
            "@context": "http://iiif.io/api/image/2/context.json",
            "@id": path,
            "@type": "iiif:Image",
            "protocol": "http://iiif.io/api/image",
            "width": self.ik_image.width,
            "height": self.ik_image.height,
            "license": ["CC"],
            "attribution": [{
                "@value": "Credit: IC Arts Collection."
                          " Provided by: Interaction Consortium.",
                "@language": "en",
            }],
        }
        self.assertEqual(expected, response.json)
        # JSON-LD response not yet supported
        response = self.app.get(
            path,
            user=self.superuser,
            headers={'accept': 'application/ld+json'},
            expect_errors=True,
        )
        self.assertEqual(501, response.status_code)
        self.assertEqual(
            "JSON-LD response is not yet supported", response.content)

    def test_iiif_image_api_basics(self):
        # Not a privileged user
        user = G(User)
        response = self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=user,
            expect_errors=True,
        )
        self.assertEqual(302, response.status_code)
        self.assertTrue(
            response.headers.get('Location', '').endswith(
                '/login/?next=/iiif/%d/full/max/0/default.jpg'
                % self.ik_image.pk))
        # Now is a privileged user
        user.user_permissions.add(
            Permission.objects.get(codename='can_use_iiif_image_api'))
        response = self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=user,
        )

        # Invalid image identifier
        response = self.app.get(
            reverse(
                'iiif_image_api',
                args=[0, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(404, response.status_code)

        # Correct use
        image = self.mock_image()
        with patch('icekit.plugins.iiif.views._get_image_or_404') as _getter:
            _getter.return_value = (self.ik_image, image)
            response = self.app.get(
                reverse(
                    'iiif_image_api',
                    args=[self.ik_image.pk,
                          'full', 'full', '0', 'default', 'jpg']),
                user=self.superuser,
            )
            # No image transform operations necessary or called, just save
            self.assertEqual(image.mock_calls, [
                call.save(ANY, format='jpeg')
            ])
            self.FileResponse.assert_called_with(
                ANY, content_type='image/jpeg')

    @patch('icekit.plugins.iiif.views._get_image_or_404')
    def test_iiif_image_api_region(self, _getter):
        # Region: full
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [call.save(ANY, format='jpeg')])
        # Region: square, 200 x 300 image
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api', args=[
                    self.ik_image.pk, 'square', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            # Auto-cropped to center square in image
            call.crop((0, 50, 200, 250)),
            call.crop().convert('RGB'),
            call.crop().convert().save(ANY, format='jpeg')
        ])
        # Region: x,y,w,h
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, '20,30,50,90',
                      'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.crop((20, 30, 70, 120)),
            call.crop().convert('RGB'),
            call.crop().convert().save(ANY, format='jpeg')
        ])
        # Region: x,y,w,h (crop isn't permitted to exceed original image)
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, '100,50,150,300',
                      'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            # Width & height reduced to fit bounds
            call.crop((100, 50, 200, 300)),
            call.crop().convert('RGB'),
            call.crop().convert().save(ANY, format='jpeg')
        ])
        # Region: pct:x,y,w,h
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'pct:10,50,75,50',
                      'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            # Width & height reduced to fit bounds
            call.crop((20, 150, 170, 300)),
            call.crop().convert('RGB'),
            call.crop().convert().save(ANY, format='jpeg')
        ])

    @patch('icekit.plugins.iiif.views._get_image_or_404')
    def test_iiif_image_api_size(self, _getter):
        # Size: max
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.save(ANY, format='jpeg')
        ])
        # Size: full
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'full', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.assertEqual(image.mock_calls, [
            call.save(ANY, format='jpeg')
        ])
        # Size: pct
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'pct:25', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.resize((image.width / 4, image.height / 4)),
            call.resize().convert('RGB'),
            call.resize().convert().save(ANY, format='jpeg')
        ])
        # Size: w,h
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', '100,150',
                      '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.resize((100, 150)),
            call.resize().convert('RGB'),
            call.resize().convert().save(ANY, format='jpeg')
        ])
        # Size: w, (maintain aspect ratio)
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', '150,', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        self.assertEqual(image.mock_calls, [
            call.resize((150, 225)),
            call.resize().convert('RGB'),
            call.resize().convert().save(ANY, format='jpeg')
        ])
        # Size: ,h (maintain aspect ratio, scale beyond original image size)
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', ',600', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.resize((400, 600)),
            call.resize().convert('RGB'),
            call.resize().convert().save(ANY, format='jpeg')
        ])
        # Size: !w,h (best-fit)
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', '!75,125',
                      '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            # Width is best fit
            call.resize((75, 112)),
            call.resize().convert('RGB'),
            call.resize().convert().save(ANY, format='jpeg')
        ])
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', '!300,240',
                      '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            # Height is best fit
            call.resize((160, 240)),
            call.resize().convert('RGB'),
            call.resize().convert().save(ANY, format='jpeg')
        ])

    @patch('icekit.plugins.iiif.views._get_image_or_404')
    def test_iiif_image_api_rotation(self, _getter):
        # Rotation: 0
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.save(ANY, format='jpeg')
        ])
        # Rotation: 360 (converted to 0 since % 360)
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse('iiif_image_api', args=[
                self.ik_image.pk, 'full', 'max', '360', 'default', 'jpg'
            ]),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.save(ANY, format='jpeg')
        ])
        # Rotation: invalid value
        response = self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', 'x', 'default', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(400, response.status_code)
        # Rotation other than 0 or 360 not yet supported
        response = self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '90', 'default', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(501, response.status_code)
        self.assertEqual(
            "Image API rotation parameters other than (0,) degrees are not"
            " yet supported: 90",
            response.content)

    @patch('icekit.plugins.iiif.views._get_image_or_404')
    def test_iiif_image_api_quality(self, _getter):
        # Quality: default
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'default', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.save(ANY, format='jpeg')
        ])
        # Quality: color
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'color', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            call.save(ANY, format='jpeg')
        ])
        # Quality: gray
        image = self.mock_image(return_from=_getter)
        self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'gray', 'jpg']),
            user=self.superuser,
        ).follow()
        self.assertEqual(image.mock_calls, [
            # Convert image to black-and-white (L) mode
            call.convert('L'),
            call.convert().save(ANY, format='jpeg')
        ])
        # Quality: bitonal (not yet supported)
        image = self.mock_image(return_from=_getter)
        response = self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk, 'full', 'max', '0', 'bitonal', 'jpg']),
            user=self.superuser,
            expect_errors=True,
        )
        self.assertEqual(501, response.status_code)
        self.assertEqual(
            "Image API quality parameters other than ('default', 'color',"
            " 'gray') are not yet supported: bitonal",
            response.content)

    @patch('icekit.plugins.iiif.views._get_image_or_404')
    def test_iiif_image_api_storage(self, _getter):
        # Enable file storage engine for this test
        from icekit.plugins.iiif import views
        views.iiif_storage = FileSystemStorage(location=tempfile.gettempdir())

        # Generate image at 10% size, manually specified
        canonical_url = reverse(
            'iiif_image_api',
            args=[self.ik_image.pk,
                  'full', '20,', '0', 'default', 'jpg'])
        image = self.mock_image(return_from=_getter)
        response = self.app.get(canonical_url, user=self.superuser)
        self.assertEqual(image.mock_calls, [
            call.resize((20, 30)),
            call.resize().convert('RGB'),
            call.resize().convert().save(ANY, format='jpeg')
        ])
        self.assertEqual(200, response.status_code)
        self.FileResponse.assert_called_with(
            ANY, content_type='image/jpeg')
        # Generate image at 10% size using pct:10, confirm we get redirected
        # to the expected canonical URL path and that image loaded from storage
        # instead of generated
        image = self.mock_image(return_from=_getter)
        response = self.app.get(
            reverse(
                'iiif_image_api',
                args=[self.ik_image.pk,
                      'full', 'pct:10', '0', 'default', 'jpg']),
            user=self.superuser,
        )
        # Redirected to canonical URL?
        self.assertEqual(302, response.status_code)
        self.assertTrue(response['location'].endswith(canonical_url))
        response = response.follow()
        self.assertEqual(200, response.status_code)
        self.assertEqual(image.mock_calls, [])  # No calls on image
        self.FileResponse.assert_called_with(
            ANY, content_type='image/jpeg')
