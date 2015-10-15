from django.contrib.auth import get_user_model
from django_dynamic_fixture import G
from django_webtest import WebTest
from fluent_pages.models import HtmlPage

from . import models
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
        self.page_1 = LayoutPage.objects.create(
            title='Test Title',
            author=self.super_user_1,
            status='p',
        )

        self.image_1 = G(
            models.Image
        )

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
