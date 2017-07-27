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
        self.test_render_template = django_engine.from_string(
            '''{% load icekit_tags %}{% render_navigation 'test-nav' %}'''
        )

    def create_request(self, path='/', is_authenticated=False):
        request = self.factory.get(path)

        class FakeAuthenticatedUser(object):
            pass
        request.user = FakeAuthenticatedUser()
        request.user.is_authenticated = is_authenticated

        return request

    def test_render_navigation_tag_renders_nothing_by_default(self):
        self.assertEqual(
            self.test_render_template.render({'request': self.create_request()}).strip(),
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
        request = self.create_request()
        test_template_rendered = self.test_render_template.render({
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
        request = self.create_request()
        test_template_rendered = self.test_render_template.render({
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
        request = self.create_request()
        test_template_rendered = self.test_render_template.render({
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
        request = self.create_request(is_authenticated=True)
        test_template_rendered = self.test_render_template.render({
            'request': request,
        })
        self.assertIn(reverse('logout'), test_template_rendered)
        self.assertIn('Logout', test_template_rendered)

    def test_navigation_can_produce_lists_of_active_items(self):
        navigation = Navigation.objects.create(
            name='test nav',
            slug='test-nav',
        )
        placeholder = Placeholder.objects.create(
            slot='navigation_content',
            parent=navigation,
        )
        navigation_item_1 = NavigationItem.objects.create(
            placeholder=placeholder,
            parent_type_id=ContentType.objects.get_for_model(Navigation).id,
            parent_id=navigation.id,
            title='test nav item title 1',
            url=AnyUrlValue.from_db_value('/test/url/')
        )
        navigation_item_2 = NavigationItem.objects.create(
            placeholder=placeholder,
            parent_type_id=ContentType.objects.get_for_model(Navigation).id,
            parent_id=navigation.id,
            title='test nav item title 2',
            url=AnyUrlValue.from_db_value('/test/url/nested/')
        )
        accounts_navigation_item = AccountsNavigationItem.objects.create(
            placeholder=placeholder,
            parent_type_id=ContentType.objects.get_for_model(Navigation).id,
            parent_id=navigation.id,
        )

        navigation.set_request(self.create_request(path='/__no_match__/'))
        self.assertEqual(navigation.active_items, [])
        del navigation.active_items

        navigation.set_request(self.create_request(path='/test/url/'))
        self.assertEqual(navigation.active_items, [navigation_item_1])
        del navigation.active_items

        navigation.set_request(self.create_request(path='/test/url/nested/'))
        self.assertEqual(navigation.active_items, [navigation_item_1, navigation_item_2])
        del navigation.active_items

        navigation.set_request(self.create_request(path=reverse('login'), is_authenticated=True))
        self.assertEqual(navigation.active_items, [])
        del navigation.active_items

        navigation.set_request(self.create_request(path=reverse('login')))
        self.assertEqual(navigation.active_items, [accounts_navigation_item])
        del navigation.active_items

        navigation.set_request(self.create_request(path=reverse('logout')))
        self.assertEqual(navigation.active_items, [])
        del navigation.active_items

        navigation.set_request(self.create_request(path=reverse('logout'), is_authenticated=True))
        self.assertEqual(navigation.active_items, [accounts_navigation_item])
        del navigation.active_items

    def test_get_navigation_tag_assigns_correctly(self):
        navigation = Navigation.objects.create(
            name='test nav',
            slug='test-nav',
        )
        Placeholder.objects.create(
            slot='navigation_content',
            parent=navigation,
        )
        template = django_engine.from_string(
            '''{% load icekit_tags %}{% get_navigation 'test-nav' as nav %}{{ nav.name }}'''
        )
        rendered = template.render({
            'request': self.create_request(),
        })
        self.assertEqual(rendered, 'test nav')

    def test_get_navigation_tag_can_be_used_for_iteration(self):
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
            title='test nav item title 1',
            url=AnyUrlValue.from_db_value('/test/url/')
        )
        NavigationItem.objects.create(
            placeholder=placeholder,
            parent_type_id=ContentType.objects.get_for_model(Navigation).id,
            parent_id=navigation.id,
            title='test nav item title 2',
            url=AnyUrlValue.from_db_value('/test/url/nested/')
        )
        template = django_engine.from_string(
            '''{% load icekit_tags %}{% get_navigation 'test-nav' as nav %}'''
            '''{% for item in nav.slots.navigation_content %}{{ item.title }} {{ item.url }} |{% endfor %}'''
        )
        rendered = template.render({
            'request': self.create_request(),
        })
        self.assertEqual(rendered, 'test nav item title 1 /test/url/ | test nav item title 2 /test/url/nested/ |')
