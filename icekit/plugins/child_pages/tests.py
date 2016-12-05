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


class ChildPagesTestCase(WebTest):
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
        )
        self.page_2 = LayoutPage.objects.create(
            title='Test Page 2',
            slug='test-page-2',
            parent_site=Site.objects.first(),
            layout=self.layout_1,
            author=self.staff_1,
        )
        self.page_3 = LayoutPage.objects.create(
            title='Test Page 3',
            slug='test-page-3',
            parent_site=Site.objects.first(),
            layout=self.layout_1,
            author=self.staff_1,
            parent=self.page_2,
        )
        self.page_4 = LayoutPage.objects.create(
            title='Test Page 4',
            slug='test-page-4',
            parent_site=Site.objects.first(),
            layout=self.layout_1,
            author=self.staff_1,
            parent=self.page_2,
        )
        self.child_pages_1 = fluent_contents.create_content_instance(
            models.ChildPageItem,
            self.page_1,
        )
        self.child_pages_2 = fluent_contents.create_content_instance(
            models.ChildPageItem,
            self.page_2,
        )

        self.page_1.publish()
        self.page_2.publish()
        self.page_3.publish()
        # page_4 is not published

    def test_str(self):
        self.assertEqual(str(self.child_pages_1), 'Child Pages')

    def test_get_child_pages_draft(self):
        self.assertEqual(len(self.child_pages_1.get_child_pages()), 0)
        self.assertEqual(len(self.child_pages_2.get_child_pages()), 2)
        expected_children = set([self.page_3.pk, self.page_4.pk])
        # test page ids, because the pages are boobytraps
        actual_children = set([x.pk for x in self.child_pages_2.get_child_pages()])
        self.assertEqual(expected_children, actual_children)

    def test_get_child_pages_published(self):
        pcp1 = self.page_1.get_published().contentitem_set.all()[0]
        pcp2 = self.page_2.get_published().contentitem_set.all()[0]

        self.assertEqual(len(pcp1.get_child_pages()), 0)
        self.assertEqual(len(pcp2.get_child_pages()), 1)
        expected_children = [self.page_3.get_published()]
        for child in expected_children:
            self.assertIn(child, pcp2.get_child_pages())
