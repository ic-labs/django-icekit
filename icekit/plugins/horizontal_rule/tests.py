from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model
from django_dynamic_fixture import G
from django_webtest import WebTest
from icekit.utils import fluent_contents
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage

from . import models

User = get_user_model()


class InstagramEmbedItemTestCase(WebTest):
    def setUp(self):
        self.layout_1 = G(
            Layout,
            template_name='layout_page/layoutpage/layouts/default.html',
        )
        self.layout_1.content_types.add(ContentType.objects.get_for_model(LayoutPage))
        self.layout_1.save()
        self.staff_1 = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.page_1 = LayoutPage.objects.create(
            title='Test Page',
            slug='test-page',
            parent_site=Site.objects.first(),
            layout=self.layout_1,
            author=self.staff_1,
            status='p',  # Publish the page
        )
        self.hr_1 = fluent_contents.create_content_instance(
            models.HorizontalRuleItem,
            self.page_1,
        )

    def test_str(self):
        self.assertEqual(str(self.hr_1), 'Horizontal Rule')
