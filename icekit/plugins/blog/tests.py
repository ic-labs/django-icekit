from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model

from django_dynamic_fixture import G
from django_webtest import WebTest
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents

from .models import Post

User = get_user_model()


class BlogPostTestCase(WebTest):
    def setUp(self):
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
        self.blog_post_1 = fluent_contents.create_content_instance(
            Post,
            self.page_1,
            title='Blog Post 1',
            body='Test Content 1',
        )
        self.anchor_2 = fluent_contents.create_content_instance(
            Post,
            self.page_1,
            title='Blog Post 2',
        )

    def test_renders_post_list(self):
        response = self.app.get(self.page_1.get_absolute_url())
        import ipdb; ipdb.set_trace()

