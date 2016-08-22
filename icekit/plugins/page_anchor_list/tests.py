from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model

from django_dynamic_fixture import G
from django_webtest import WebTest
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents
from icekit.plugins.page_anchor.models import PageAnchorItem

from . import models

User = get_user_model()


class PageAnchorItemTestCase(WebTest):
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
        self.anchor_1 = fluent_contents.create_content_instance(
            PageAnchorItem,
            self.page_1,
            anchor_name='Jump Link'
        )
        self.anchor_2 = fluent_contents.create_content_instance(
            PageAnchorItem,
            self.page_1,
            anchor_name='Second Jump Link'
        )

        self.anchor_list = fluent_contents.create_content_instance(
            models.PageAnchorListItem,
            self.page_1,
        )
        self.page_1.publish()
        self.page_1_published = self.page_1.get_published()

    def test_renders_anchor_list(self):
        response = self.app.get(self.page_1_published.get_absolute_url())
        published_anchor_1 = self.page_1_published.contentitem_set.get(
            pageanchoritem__anchor_name='Jump Link')
        response.mustcontain(
            '<a class="page-anchor-list-item" href="#jump-link-%d">Jump Link</a>'
            % published_anchor_1.pk)
        published_anchor_2 = self.page_1_published.contentitem_set.get(
            pageanchoritem__anchor_name='Second Jump Link')
        response.mustcontain(
            '<a class="page-anchor-list-item" href="#second-jump-link-%d">Second Jump Link</a>'
            % published_anchor_2.pk)

    def test_str(self):
        self.assertEqual(str(self.anchor_list), 'Page Anchor List')
