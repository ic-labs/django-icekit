import os
from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model
from django_dynamic_fixture import G
from django_webtest import WebTest
from icekit.utils import fluent_contents
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from mock import Mock

from . import models

User = get_user_model()


class File(WebTest):
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
        self.file = G(models.File)
        self.file_2 = G(
            models.File,
            ignore_fields=['title', ],
        )
        self.file_item = fluent_contents.create_content_instance(
            models.FileItem,
            self.page_1,
            file=self.file
        )

    def test_str(self):
        self.assertEqual(str(self.file), self.file.title)
        self.assertEqual(str(self.file_2), os.path.basename(self.file_2.file.name).split('.')[0])
        self.assertEqual(str(self.file_item), str(self.file))

    def test_file_size(self):
        mock_file = Mock()
        mock_file.size = 1823182038
        original_file = self.file.file
        self.file.file = mock_file
        self.assertEqual(self.file.file_size(), u'1.7\xa0GB')
        self.file.file = original_file

    def test_extension(self):
        self.assertEqual(self.file.extension(), '')

        mock_file = Mock()
        mock_file.name = 'this.is.a.test'
        original_file = self.file_2.file
        self.file_2.file = mock_file
        self.assertEqual(self.file_2.extension(), 'test')
        self.file_2.file = original_file

    def tearDown(self):
        self.file_item.delete()
        self.file_2.delete()
        self.file.delete()
        self.page_1.delete()
        self.staff_1.delete()
        self.layout_1.delete()
