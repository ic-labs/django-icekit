from django.contrib.contenttypes.models import ContentType
from django.core.urlresolvers import reverse
from django.template.loader import get_template
from django.test import TestCase
from django.test.client import RequestFactory
from django.template import engines
from any_urlfield.models import AnyUrlValue
from fluent_contents.models import Placeholder
from icekit.navigation.models import Navigation, NavigationItem, AccountsNavigationItem

django_engine = engines['django']


class TestNavigation(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.test_template = django_engine.from_string(
            '''{% load icekit_tags %}{% render_navigation 'test-nav' %}'''
        )

    def test_render_navigation_tag_renders_nothing_by_default(self):
        self.assertEqual(
            self.test_template.render({}).strip(),
            '',
        )

    def test_render_navigation_tag_renders_navigation_using_expected_template(self):
        navigation = Navigation.objects.create(
            name='test nav',
            slug='test-nav',
        )
        Placeholder.objects.create(
            slot='navigation_content',
            parent=navigation,
        )
        request = self.factory.get('/')
        test_template_rendered = self.test_template.render({
            'request': request,
        })
        expected_output = get_template('icekit/navigation/navigation.html').render({
            'request': request,
            'navigation': navigation,
        })
        self.assertEqual(test_template_rendered, expected_output)

    def test_navigation_can_be_rendered_with_navigation_items(self):
        navigation = Navigation.objects.create(
            name='test nav',
            slug='test-nav',
        )
        placeholder = Placeholder.objects.create(
            slot='navigation_content',
            parent=navigation,
        )
        NavigationItem.objects.create(
            placeholder=placeholder,
            parent_type_id=ContentType.objects.get_for_model(Navigation).id,
            parent_id=navigation.id,
            title='test nav item title',
            url=AnyUrlValue.from_db_value('http://example.com/')
        )
        request = self.factory.get('/')
        test_template_rendered = self.test_template.render({
            'request': request,
        })
        self.assertIn('href="http://example.com/"', test_template_rendered)
        self.assertIn('test nav item title', test_template_rendered)

    def test_navigation_can_be_rendered_with_accounts_navigation_items_for_anon_users(self):
        navigation = Navigation.objects.create(
            name='test nav',
            slug='test-nav',
        )
        placeholder = Placeholder.objects.create(
            slot='navigation_content',
            parent=navigation,
        )
        AccountsNavigationItem.objects.create(
            placeholder=placeholder,
            parent_type_id=ContentType.objects.get_for_model(Navigation).id,
            parent_id=navigation.id,
        )
        request = self.factory.get('/')
        test_template_rendered = self.test_template.render({
            'request': request,
        })
        self.assertIn(reverse('login'), test_template_rendered)
        self.assertIn('Login', test_template_rendered)

    def test_navigation_can_be_rendered_with_accounts_navigation_items_for_users(self):
        navigation = Navigation.objects.create(
            name='test nav',
            slug='test-nav',
        )
        placeholder = Placeholder.objects.create(
            slot='navigation_content',
            parent=navigation,
        )
        AccountsNavigationItem.objects.create(
            placeholder=placeholder,
            parent_type_id=ContentType.objects.get_for_model(Navigation).id,
            parent_id=navigation.id,
        )
        request = self.factory.get('/')
        request.user = {'is_authenticated': True}
        test_template_rendered = self.test_template.render({
            'request': request,
        })
        self.assertIn(reverse('logout'), test_template_rendered)
        self.assertIn('Logout', test_template_rendered)
