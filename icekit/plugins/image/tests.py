from unittest import skip

from django.contrib.auth import get_user_model
from django.contrib.contenttypes.models import ContentType
from django_dynamic_fixture import G
from django_webtest import WebTest
from easy_thumbnails.files import get_thumbnailer
from icekit.utils.testing import get_test_image, setup_with_context_manager

from . import models
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents

User = get_user_model()


class ImageItem(WebTest):
    def setUp(self):
        self.super_user_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.layout = G(
            Layout,
            template_name='layout_page/layoutpage/layouts/default.html',
        )
        self.layout.content_types.add(ContentType.objects.get_for_model(LayoutPage))
        self.page_1 = LayoutPage.objects.create(
            title='Test Title',
            author=self.super_user_1,
            status='p',
            layout=self.layout,
        )

        self.image_1 = G(
            models.Image
        )

        self._image_name = setup_with_context_manager(
            self, get_test_image(self.image_1.image.storage)
        ) # context is automatically exited on teardown.

        self.image_1.image = self._image_name
        self.image_1.save()

        self.image_item_1 = fluent_contents.create_content_instance(
            models.ImageItem,
            self.page_1,
            image=self.image_1,
        )

    def test_caption_property(self):
        test_text = '<div>test</div>'
        self.assertEqual(self.image_1.caption, self.image_item_1.caption)
        self.image_item_1.caption_override = test_text
        self.assertEqual(self.image_item_1.caption, test_text)
        del self.image_item_1.caption
        self.assertEqual(self.image_1.caption, self.image_item_1.caption)
        self.image_item_1.caption = test_text
        self.assertEqual(self.image_item_1.caption, test_text)

    def test_render(self):
        self.page_1.publish()
        response = self.app.get(self.page_1.publishing_linked.get_absolute_url())
        self.assertEqual(response.status_code, 200)
        # Confirm our icekit/plugins/image/default.html template is used to
        # help render the page. We cannot lookup `response.templates` because
        # this will only be fully populated if the `ImagePlugin` has not yet
        # been rendered and cached. That is, enabling caching for unit test
        # runs will cause `response.templates` comparisons to be unreliable.
        self.assertTrue('<div class="image-container">' in response.content)

        thumb_url = get_thumbnailer(self.image_1.image)['content_image'].url
        self.assertTrue(thumb_url)
        self.assertTrue('src="%s"' % thumb_url in response.content)
