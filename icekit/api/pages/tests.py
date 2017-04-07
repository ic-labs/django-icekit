from django.core.urlresolvers import reverse

from django_dynamic_fixture import G

from fluent_contents.plugins.rawhtml.models import RawHtmlItem

from icekit import models
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents


from ..base_tests import BaseAPITestCase


class PagesAPITests(BaseAPITestCase):
    API_NAME = 'page'

    def setUp(self):
        super(PagesAPITests, self).setUp()

        self.layout_1 = G(
            models.Layout,
            template_name='icekit/layouts/default.html',
        )
        self.layoutpage_1 = LayoutPage.objects.create(
            author=self.superuser,
            title='Test LayoutPage',
            layout=self.layout_1,
        )
        self.content_instance_1 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage_1,
            html='<b>test 1</b>'
        )
        self.content_instance_2 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage_1,
            html='<b>test 2</b>'
        )
        self.content_instance_3 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage_1,
            html='<b>test 3</b>'
        )

    def test_page_api(self):
        self.layoutpage_1.publish()
        for j in range(20):
            published_layoutpage = LayoutPage.objects.create(
                author=self.superuser,
                title='Test LayoutPage %s' % j,
                layout=self.layout_1,
            )
            published_layoutpage.publish()

            LayoutPage.objects.create(
                author=self.superuser,
                title='Draft LayoutPage %s' % j,
                layout=self.layout_1,
            )

        response = self.client.get(self.listing_url())
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data['results']), 5)
        self.assertEqual(response.data['count'], 21)
        response = self.client.get(self.detail_url(self.layoutpage_1.id))
        self.assertEqual(response.status_code, 404)
        response = self.client.get(
            self.detail_url(self.layoutpage_1.get_published().id))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 6)
        for key in response.data.keys():
            if key is not 'content':
                self.assertEqual(
                    response.data[key],
                    getattr(self.layoutpage_1.get_published(), key))
        self.assertEqual(len(response.data['content']), 3)
        for number, item in enumerate(response.data['content'], 1):
            self.assertEqual(
                item['content'],
                getattr(self, 'content_instance_%s' % number).html)

    def test_api_user_permissions_are_correct(self):
        self.layoutpage_1.publish()
        page_published_id = self.layoutpage_1.get_published().pk

        # Anonymous user can peform all read operations, no write operations
        self.client.credentials()  # Clear any user credentials
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, page_published_id)
        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(False, page_published_id)
        self.assert_user_has_patch_permission(False, page_published_id)
        self.assert_user_has_delete_permission(False, page_published_id)

        # Even superuser cannot peform write operations
        self.client_apply_token(self.superuser_token)
        self.assert_user_has_get_list_permission(True)
        self.assert_user_has_get_detail_permission(True, page_published_id)
        self.assert_user_has_post_permission(False)
        self.assert_user_has_put_permission(False, page_published_id)
        self.assert_user_has_patch_permission(False, page_published_id)
        self.assert_user_has_delete_permission(False, page_published_id)
