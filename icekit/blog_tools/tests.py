from django.utils.timezone import now
from django_dynamic_fixture import G
from django_webtest import WebTest

from . import abstract_models, models
from icekit.plugins.image.models import Image


class Models(WebTest):
    def test_content_category(self):
        content_category = G(models.ContentCategory)
        self.assertEqual(content_category.name, str(content_category))
        content_category.delete()

    def test_location(self):
        location = G(models.Location)
        self.assertEqual(location.name, str(location))
        location.delete()

    def test_blog_post(self):
        blog_post = G(models.BlogPost)
        self.assertEqual(blog_post.title, str(blog_post))
        blog_post.delete()

    def test_event_range_mixin(self):
        dt = now().date()
        event_range_mixin = abstract_models.EventRangeMixin()
        event_range_mixin.event_start = dt
        event_range_mixin.event_end = dt

        self.assertEqual(str(event_range_mixin), '%s - %s' % (dt, dt))

    def test_optional_location_mixin(self):
        location_mixin = abstract_models.OptionalLocationMixin()

        self.assertEqual(str(location_mixin), '')
        location = G(models.Location)
        location_mixin.location = location
        self.assertEqual(str(location_mixin), str(location_mixin.location))
        location.delete()

    def test_single_category_mixin(self):
        category_mixin = abstract_models.SingleCategoryMixin()
        content_category = G(models.ContentCategory)
        category_mixin.category = content_category
        self.assertEqual(str(category_mixin), str(content_category))
        content_category.delete()

    def test_single_photo_mixin(self):
        photo_mixin = abstract_models.SinglePhotoMixin()
        self.assertEqual(str(photo_mixin), '')

        image = G(Image)
        photo_mixin.photo = image

        self.assertEqual(str(photo_mixin), str(image))
        image.delete()
