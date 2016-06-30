from django.contrib.auth import get_user_model
from django.contrib.sites.models import Site
from django_dynamic_fixture import G
from django_webtest import WebTest
from fluent_pages.models import PageLayout
from fluent_pages.pagetypes.fluentpage.models import FluentPage

from . import descriptors
from icekit.utils import fluent_contents
from icekit.plugins.horizontal_rule.models import HorizontalRuleItem

User = get_user_model()


class PlaceholderDescriptor(WebTest):
    def setUp(self):
        self.site, __ = Site.objects.get_or_create(
            pk=1,
            defaults={'name': 'example.com', 'domain': 'example.com'})
        self.user_1 = G(User)
        descriptors.contribute_to_class(FluentPage)
        self.page_layout_1 = G(
            PageLayout,
            template_path='icekit/layouts/default.html',
        )
        self.page_1 = FluentPage.objects.create(
            author=self.user_1,
            title='Test title',
            layout=self.page_layout_1,
        )

    def test_descriptor(self):
        self.assertIsInstance(FluentPage.slots, descriptors.PlaceholderDescriptor)
        self.assertFalse(hasattr(self.page_1.slots, 'main'))
        horizontal_rule_1 = fluent_contents.create_content_instance(
            HorizontalRuleItem,
            self.page_1
        )
        self.assertEqual(self.page_1.slots.main.count(), 1)
        with self.assertRaises(AttributeError):
            getattr(self.page_1.slots, 'fake_slot')
        horizontal_rule_1.delete()
        self.assertEqual(self.page_1.slots.main.count(), 0)

        # Test that the same object is not returned. For context, we have had previous issues with
        # slots which were bound to class objects and cached across instances.
        self.assertNotEqual(self.page_1.slots, self.page_1.slots)

    def tearDown(self):
        self.page_1.delete()
        self.page_layout_1.delete()
        self.site.delete()
