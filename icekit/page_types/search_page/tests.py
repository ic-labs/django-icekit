from django.contrib.auth import get_user_model
from django_dynamic_fixture import G
from django_webtest import WebTest

from . import models


User = get_user_model()


class SearchPage(WebTest):
    def setUp(self):
        self.super_user_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.page_1 = models.SearchPage.objects.create(
            title='Test title',
            author=self.super_user_1,
            status='p'
        )
        self.page_1.publish()

    def test_extra_context(self):
        response = self.app.get(self.page_1.publishing_linked.get_absolute_url())
        response.mustcontain("<!-- placeholder 'main' does not yet exist -->")
