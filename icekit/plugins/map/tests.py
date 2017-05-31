from mock import patch

from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.contrib.auth import get_user_model
from django.core import exceptions

from django_dynamic_fixture import G
from django_webtest import WebTest
from icekit.models import Layout
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents

from . import models

User = get_user_model()


class MapItemTestCase(WebTest):
    def setUp(self):
        self.embed_code = '''
            <iframe 
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3312.0476344648832!2d151.19845715159963!3d-33.88842702741586!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x6b12b1d842ee9aa9%3A0xb0a19ac433ef0be8!2sThe+Interaction+Consortium!5e0!3m2!1sen!2sau!4v1496201264670" 
                width="600" 
                height="450" 
                frameborder="0" 
                style="border:0" 
                allowfullscreen
            ></iframe>
        '''
        self.cleaned_embed_code = '<iframe allowfullscreen="" frameborder="0" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3312.0476344648832!2d151.19845715159963!3d-33.88842702741586!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x6b12b1d842ee9aa9%3A0xb0a19ac433ef0be8!2sThe+Interaction+Consortium!5e0!3m2!1sen!2sau!4v1496201264670" style="border: 0;"></iframe>'

        self.layout_1 = G(
            Layout,
            template_name='icekit/layouts/default.html',
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
        self.page_1.status = LayoutPage.PUBLISHED
        self.page_1.save()

        self.map_1 = fluent_contents.create_content_instance(
            models.MapItem,
            self.page_1,
            _embed_code=self.embed_code,
        )

        self.map_item = models.MapItem(
            parent_type=ContentType.objects.get_for_model(type(self.page_1)),
            parent_id=self.page_1.id,
            placeholder=self.page_1.get_placeholder_by_slot('main')[0],
            _embed_code=self.embed_code,
        )

        self.page_1.publish()

    def test_map_renders(self):
        response = self.app.get(self.page_1.get_published().get_absolute_url())
        response.mustcontain(self.cleaned_embed_code)

    def test_cleaned_embed_code(self):
        self.assertEqual(self.map_1._cleaned_embed_code.strip(), self.cleaned_embed_code)
