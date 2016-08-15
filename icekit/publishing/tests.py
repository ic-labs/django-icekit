# -*- coding: utf-8 -*-
from datetime import timedelta
import urlparse

from django.contrib.auth import get_user_model
from django.contrib.auth.models import AnonymousUser, Group
from django.contrib.sites.models import Site
from django.core.urlresolvers import reverse
from django.http import HttpResponseNotFound, QueryDict
from django.test import TestCase, TransactionTestCase, RequestFactory
from django.test.utils import override_settings, modify_settings
from django.utils import timezone

from django_webtest import WebTest

from mock import patch, Mock

from django_dynamic_fixture import G

from fluent_contents.plugins.rawhtml.models import RawHtmlItem

from fluent_pages.models.db import UrlNode

from icekit.models import Layout
from icekit.plugins.slideshow.models import SlideShow
from icekit.page_types.layout_page.models import LayoutPage
from icekit.utils import fluent_contents

from icekit.publishing.managers import DraftItemBoobyTrap, \
    UrlNodeQuerySetWithPublishingFeatures
from icekit.publishing.middleware import PublishingMiddleware, \
    is_publishing_middleware_active, get_current_user, \
    is_draft_request_context, override_current_user, \
    override_draft_request_context, override_publishing_middleware_active
from icekit.publishing.utils import get_draft_hmac, verify_draft_url, \
    get_draft_url, PublishingException, NotDraftException
from icekit.publishing.tests_base import BaseAdminTest
from icekit.tests.models import LayoutPageWithRelatedPages, \
    UnpublishableLayoutPage, Article

User = get_user_model()


class TestPublishingModelAndQueryset(TestCase):
    """
    Test base publishing features, and that publishing works as expected for
    simple models (as opposed to Fluent content or page models)
    """

    def setUp(self):
        self.site, __ = Site.objects.get_or_create(
            pk=1,
            defaults={'name': 'example.com', 'domain': 'example.com'})
        self.user_1 = G(User)
        self.page_layout_1 = G(Layout)
        self.page_1 = LayoutPage.objects.create(
            author=self.user_1,
            title='Test title',
            layout=self.page_layout_1,
        )
        self.staff_1 = User.objects.create(
            username='staff_1',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        # Create initial publishable SlideShow
        self.slide_show_1 = SlideShow.objects.create(
            title='Test Slideshow',
        )

    def test_model_publish_assert_draft_check(self):
        self.slide_show_1.publish()
        try:
            self.slide_show_1.get_published().publish()
            self.fail("Expected NotDraftException")
        except NotDraftException:
            pass

    def test_model_publishing_status_attributes(self):
        """
        Test published and draft model status flags, especially the `is_dirty`
        flag and related timestamps that affect the dirty checking logic in
        ``PublishingModelBase.is_dirty``
        """
        draft_instance = self.slide_show_1
        self.assertIsNone(draft_instance.publishing_linked)
        self.assertIsNone(draft_instance.publishing_published_at)
        self.assertTrue(draft_instance.is_draft)
        self.assertFalse(draft_instance.is_published)
        # An unpublished instance is always considered dirty
        self.assertTrue(draft_instance.is_dirty)

        # Publish instance; check status flags and timestamps are correct
        draft_instance.publish()
        published_instance = draft_instance.publishing_linked
        self.assertIsNotNone(published_instance.publishing_draft)
        self.assertIsNotNone(published_instance.publishing_published_at)
        self.assertFalse(published_instance.is_draft)
        self.assertTrue(published_instance.is_published)
        # A published instance is never dirty
        self.assertFalse(published_instance.is_dirty)

        # Check original draft item has correct status flags after publish
        draft_instance = published_instance.publishing_draft
        self.assertIsNotNone(draft_instance.publishing_linked)
        self.assertIsNotNone(draft_instance.publishing_published_at)
        self.assertTrue(draft_instance.is_draft)
        self.assertFalse(draft_instance.is_published)
        # Publishing timestamps correct?
        self.assertTrue(
            draft_instance.publishing_modified_at <
            draft_instance.publishing_linked.publishing_modified_at)
        # Draft instance is no longer dirty after publishing
        self.assertFalse(draft_instance.is_dirty)

        # Modify the draft item, so published item is no longer up-to-date
        draft_instance.title = draft_instance.title + ' changed'
        draft_instance.save()
        # Draft instance is now dirty after modification
        self.assertTrue(
            draft_instance.publishing_modified_at >
            draft_instance.publishing_linked.publishing_modified_at)
        self.assertTrue(draft_instance.is_dirty)

        # Unpublish instance; check status flags again
        draft_instance.unpublish()
        self.assertIsNone(draft_instance.publishing_linked)
        self.assertIsNone(draft_instance.publishing_published_at)
        self.assertTrue(draft_instance.is_draft)
        self.assertFalse(draft_instance.is_published)
        # Draft instance is dirty after unpublish
        self.assertTrue(draft_instance.is_dirty)

    def test_model_get_visible(self):
        # In non-draft context...
        with patch('icekit.publishing.models.is_draft_request_context') as p:
            p.return_value = False
            # Draft-only item returns None for visible
            self.assertIsNone(self.slide_show_1.get_visible())
            # Published item returns published copy for visible
            self.slide_show_1.publish()
            self.assertEqual(
                self.slide_show_1.publishing_linked,
                self.slide_show_1.get_visible())
            self.assertEqual(
                self.slide_show_1.publishing_linked,
                self.slide_show_1.publishing_linked.get_visible())
        # In draft context...
        with patch('icekit.publishing.models.is_draft_request_context') as p:
            p.return_value = True
            # Published item returns its draft for visible
            self.assertEqual(
                self.slide_show_1, self.slide_show_1.get_visible())
            self.assertEqual(
                self.slide_show_1,
                self.slide_show_1.publishing_linked.get_visible())
            # Draft-only item returns itself for visible
            self.slide_show_1.unpublish()
            self.assertEqual(
                self.slide_show_1, self.slide_show_1.get_visible())

    def test_model_is_visible(self):
        with patch('icekit.publishing.models.is_draft_request_context') as p:
            # Draft is not visible in non-draft context
            p.return_value = False
            self.assertFalse(self.slide_show_1.is_visible)
            # Draft is visible in draft context
            p.return_value = True
            self.assertTrue(self.slide_show_1.is_visible)
        self.slide_show_1.publish()
        with patch('icekit.publishing.models.is_draft_request_context') as p:
            p.return_value = False
            # Draft is not visible in non-draft context
            self.assertFalse(self.slide_show_1.is_visible)
            # Published copy is visible in non-draft context
            self.assertTrue(self.slide_show_1.publishing_linked.is_visible)
            p.return_value = True
            # Draft is visible in draft context
            self.assertTrue(self.slide_show_1.is_visible)
            # Published copy is not visible in draft context (otherwise both
            # draft and published copies of an item could be shown)
            self.assertFalse(self.slide_show_1.publishing_linked.is_visible)

    def test_model_is_within_publication_dates(self):
        # Empty publication start/end dates
        self.assertTrue(self.page_1.is_within_publication_dates())
        # Test publication start date
        self.page_1.publication_date = timezone.now() - timedelta(seconds=1)
        self.page_1.save()
        self.assertTrue(self.page_1.is_within_publication_dates())
        self.page_1.publication_date = timezone.now() + timedelta(seconds=1)
        self.page_1.save()
        self.assertFalse(self.page_1.is_within_publication_dates())
        # Reset
        self.page_1.publication_date = None
        self.page_1.save()
        self.assertTrue(self.page_1.is_within_publication_dates())
        # Test publication end date
        self.page_1.publication_end_date = \
            timezone.now() + timedelta(seconds=1)
        self.page_1.save()
        self.assertTrue(self.page_1.is_within_publication_dates())
        self.page_1.publication_end_date = \
            timezone.now() - timedelta(seconds=1)
        self.page_1.save()
        self.assertFalse(self.page_1.is_within_publication_dates())
        # Reset
        self.page_1.publication_end_date = None
        self.page_1.save()
        self.assertTrue(self.page_1.is_within_publication_dates())
        # Test both publication start and end dates against arbitrary timestamp
        self.page_1.publication_date = timezone.now() - timedelta(seconds=1)
        self.page_1.publication_end_date = \
            timezone.now() + timedelta(seconds=1)
        self.assertTrue(self.page_1.is_within_publication_dates())
        self.assertTrue(
            self.page_1.is_within_publication_dates(timezone.now()))
        # Timestamp exactly at publication start date is acceptable
        self.assertTrue(
            self.page_1.is_within_publication_dates(
                self.page_1.publication_date))
        # Timestamp exactly at publication end date is not acceptable
        self.assertFalse(
            self.page_1.is_within_publication_dates(
                self.page_1.publication_end_date))

    def test_model_is_published(self):
        # Only actual published copy returns True for `is_published`
        self.assertFalse(self.slide_show_1.is_published)
        self.slide_show_1.publish()
        self.assertFalse(self.slide_show_1.is_published)
        self.assertTrue(self.slide_show_1.publishing_linked.is_published)

    def test_queryset_draft_with_publishing_model(self):
        self.assertEqual(
            [self.slide_show_1], list(SlideShow.objects.draft()))
        # Only draft items returned even when published
        self.slide_show_1.publish()
        self.assertEqual(
            [self.slide_show_1], list(SlideShow.objects.draft()))
        # Confirm we only get draft items regardless of
        # `is_draft_request_context`
        with override_settings(DEBUG=True):
            with patch('icekit.publishing.managers'
                       '.is_draft_request_context') as p:
                p.return_value = False
                self.assertEqual(
                    [self.slide_show_1], list(SlideShow.objects.draft()))

    def test_queryset_published_with_publishing_model(self):
        self.assertEqual(
            [], list(SlideShow.objects.published()))
        self.slide_show_1.publish()
        # Return only published items
        self.assertEqual(
            [self.slide_show_1.publishing_linked],  # Compare published copy
            list(SlideShow.objects.published()))
        # Confirm we only get published items regardless of
        # `is_draft_request_context`
        with patch('icekit.publishing.managers.is_draft_request_context') as p:
            p.return_value = True
            self.assertEqual(
                [self.slide_show_1.publishing_linked],
                list(SlideShow.objects.published()))
        # Delegates to `visible` if `for_user` provided
        with patch('icekit.publishing.managers.PublishingQuerySet.visible') \
                as p:
            p.return_value = 'success!'
            self.assertEqual(
                'success!',
                SlideShow.objects.published(for_user=self.staff_1))
            self.assertEqual(
                'success!', SlideShow.objects.published(for_user=None))
            self.assertEqual(
                'success!', SlideShow.objects.published(for_user='whatever'))
        # Confirm draft-for-published exchange is disabled by default...
        self.slide_show_1.unpublish()
        self.assertEqual(
            set([]), set(SlideShow.objects.published()))
        # ... but exchange can be forced
        self.slide_show_1.publish()
        self.assertEqual(
            set([self.slide_show_1.publishing_linked]),
            set(SlideShow.objects.published(force_exchange=True)))

    def test_queryset_published_with_urlnode_based_publishing_model(self):
        self.assertEqual(
            [], list(LayoutPage.objects.published()))
        self.page_1.publish()
        # Return only published items
        self.assertEqual(
            [self.page_1.publishing_linked],  # Compare published copy
            list(LayoutPage.objects.published()))
        # Confirm we only get published items regardless of
        # `is_draft_request_context`
        with patch('icekit.publishing.apps.is_draft_request_context') as p:
            p.return_value = True
            self.assertEqual(
                [self.page_1.publishing_linked],
                list(LayoutPage.objects.published()))
        # Delegates to `visible` if `for_user` provided
        with patch('icekit.publishing.managers.PublishingQuerySet.visible') \
                as p:
            p.return_value = 'success!'
            self.assertEqual(
                'success!',
                LayoutPage.objects.published(for_user=self.staff_1))
            self.assertEqual(
                'success!', LayoutPage.objects.published(for_user=None))
            self.assertEqual(
                'success!', LayoutPage.objects.published(for_user='whatever'))
        # Confirm draft-for-published exchange is disabled by default...
        self.page_1.unpublish()
        self.assertEqual(
            set([]), set(LayoutPage.objects.published()))
        # ... but exchange can be forced
        self.page_1.publish()
        self.assertEqual(
            set([self.page_1.publishing_linked]),
            set(LayoutPage.objects.published(force_exchange=True)))

    def test_queryset_visible(self):
        self.slide_show_1.publish()
        # In draft mode, `visible` delegates to `draft`
        draft_set = set(SlideShow.objects.draft())
        with patch('icekit.publishing.managers.is_draft_request_context') as p:
            p.return_value = True
            self.assertEqual(draft_set, set(SlideShow.objects.visible()))
        # In non-draft mode, `visible` delegates to `published`
        published_set = set(SlideShow.objects.published())
        with patch('icekit.publishing.managers.is_draft_request_context') as p:
            p.return_value = False
            self.assertEqual(published_set, set(SlideShow.objects.visible()))

    def test_queryset_exchange_for_published(self):
        # Exchanging draft-only items gives no results
        self.assertEqual([self.slide_show_1], list(SlideShow.objects.all()))
        self.assertEqual(
            [], list(SlideShow.objects.draft().exchange_for_published()))
        # Exchanging published draft items gives published copies
        self.slide_show_1.publish()
        self.assertEqual(
            [self.slide_show_1.publishing_linked],
            list(SlideShow.objects.draft().exchange_for_published()))
        # Ordering of items in incoming QS is retained in exchange
        SlideShow.objects.create(title='Z')
        SlideShow.objects.create(title='Y')
        SlideShow.objects.create(title='X')
        SlideShow.objects.create(title='W')
        qs = SlideShow.objects.order_by('-pk')
        self.assertEqual(
            [p.pk for p in qs.filter(publishing_is_draft=False)],
            [p.pk for p in qs.exchange_for_published()])
        qs = SlideShow.objects.order_by('pk')
        self.assertEqual(
            [p.pk for p in qs.filter(publishing_is_draft=False)],
            [p.pk for p in qs.exchange_for_published()])

    def test_draft_item_booby_trap(self):
        # Published item cannot be wrapped by DraftItemBoobyTrap
        self.slide_show_1.publish()
        try:
            DraftItemBoobyTrap(self.slide_show_1.get_published())
            self.fail("Expected ValueError wrapping a published item")
        except ValueError, ex:
            self.assertTrue('is not a DRAFT' in ex.message)

        # Wrap draft item
        wrapper = DraftItemBoobyTrap(self.slide_show_1)

        # Check permitted fields/methods return expected results
        self.assertEqual(self.slide_show_1, wrapper.get_draft_payload())
        self.assertEqual(
            self.slide_show_1.get_published(), wrapper.get_published())
        self.assertEqual(
            self.slide_show_1.get_visible(), wrapper.get_visible())
        self.assertEqual(
            self.slide_show_1.publishing_linked, wrapper.publishing_linked)
        self.assertEqual(
            self.slide_show_1.publishing_linked_id,
            wrapper.publishing_linked_id)
        self.assertEqual(
            self.slide_show_1.publishing_is_draft, wrapper.publishing_is_draft)
        self.assertEqual(
            self.slide_show_1.is_published, wrapper.is_published)
        self.assertEqual(
            self.slide_show_1.has_been_published, wrapper.has_been_published)
        self.assertEqual(
            self.slide_show_1.is_draft, wrapper.is_draft)
        self.assertEqual(
            self.slide_show_1.is_visible, wrapper.is_visible)
        self.assertEqual(
            self.slide_show_1.pk, wrapper.pk)

        # Check not-permitted fields/methods raise exception
        try:
            wrapper.title
            self.fail("Expected PublishingException")
        except PublishingException, ex:
            self.assertTrue(
                "Illegal attempt to access 'title' on the DRAFT"
                in ex.message)
        try:
            wrapper.show_title
            self.fail("Expected PublishingException")
        except PublishingException, ex:
            self.assertTrue(
                "Illegal attempt to access 'show_title' on the DRAFT"
                in ex.message)

    def test_queryset_iterator(self):
        self.slide_show_1.publish()
        # Confirm drafts are wrapped with booby trap on iteration over
        # publishable QS in a public request context.
        with override_publishing_middleware_active(True):
            self.assertTrue(all(
                [i.__class__ == DraftItemBoobyTrap
                    for i in SlideShow.objects.all() if i.is_draft]))
            # Published items are never wrapped
            self.assertTrue(all(
                [i.__class__ != DraftItemBoobyTrap
                    for i in SlideShow.objects.all() if i.is_published]))
            # Confirm drafts returned as normal when in draft context
            with override_draft_request_context(True):
                self.assertTrue(all(
                    [i.__class__ != DraftItemBoobyTrap
                     for i in SlideShow.objects.all() if i.is_draft]))
            # Confirm booby trap works for generic `UrlNode` QS iteration
            self.assertTrue(all(
                [i.__class__ == DraftItemBoobyTrap
                 for i in UrlNode.objects.filter(status=UrlNode.DRAFT)]))
            self.assertTrue(all(
                [i.__class__ != DraftItemBoobyTrap
                 for i in UrlNode.objects.filter(status=UrlNode.PUBLISHED)]))

    def test_queryset_only(self):
        # Check `publishing_is_draft` is always included in `only` filtering
        qs = SlideShow.objects.only('pk')
        self.assertEqual(
            set(['id', 'publishing_is_draft']),
            qs.query.get_loaded_field_names()[SlideShow])
        qs = SlideShow.objects.only('pk', 'publishing_is_draft')
        self.assertEqual(
            set(['id', 'publishing_is_draft']),
            qs.query.get_loaded_field_names()[SlideShow])

    def test_model_get_draft(self):
        self.slide_show_1.publish()
        self.assertEqual(
            self.slide_show_1, self.slide_show_1.get_draft())
        self.assertEqual(
            self.slide_show_1, self.slide_show_1.publishing_linked.get_draft())

    def test_model_get_published(self):
        self.assertIsNone(self.slide_show_1.get_published())
        self.slide_show_1.publish()
        self.assertEqual(
            self.slide_show_1.publishing_linked,
            self.slide_show_1.get_published())
        self.assertEqual(
            self.slide_show_1.publishing_linked,
            self.slide_show_1.publishing_linked.get_published())

    def test_urlnodequerysetwithpublishingfeatures_for_publishing_model(self):
        # Create page with related pages relationships to Fluent Page
        test_page = LayoutPageWithRelatedPages.objects.create(
            author=self.user_1,
            title='Test Page',
            layout=self.page_layout_1,
        )
        test_page.related_pages.add(self.page_1)
        self.page_1.publish()
        self.assertEqual(
            set([self.page_1]),
            set(test_page.related_pages.all()))
        # Confirm relationship queryset is monkey-patched
        self.assertEqual(
            UrlNodeQuerySetWithPublishingFeatures,
            type(test_page.related_pages.all()))
        # Published -- exchange of draft-to-published items by default
        self.assertEqual(
            set([self.page_1.get_published()]),
            set(test_page.related_pages.published()))
        # Published -- exchange of draft-to-published items can be disabled
        self.assertEqual(
            set([]),
            set(test_page.related_pages.published(force_exchange=False)))
        # Draft
        self.assertEqual(
            set([self.page_1]),
            set(test_page.related_pages.draft()))
        # Visible - published items unless we are in privileged context
        self.assertEqual(
            set([self.page_1.get_published()]),
            set(test_page.related_pages.visible()))
        with override_draft_request_context(True):
            self.assertEqual(
                set([self.page_1]),
                set(test_page.related_pages.visible()))


class TestDjangoDeleteCollectorPatchForProxyModels(TransactionTestCase):
    """
    Make sure we can delete the whole object tree for Fluent pages, or other
    similar models, that have non-abstract Proxy model instance ancestors
    and where a relationship exists to the proxy ancestor.  Django does not
    otherwise properly collect and delete the proxy model's DB record in this
    case, at least prior to 1.10.

    These tests will fail if the monkey-patches like
    `APPLY_patch_django_18_get_candidate_relations_to_delete` are not applied
    with error like:

        IntegrityError: update or delete on table "fluent_pages_urlnode"
        violates foreign key constraint
        "fluent_pa_master_id_5300b55ee85000a1_fk_fluent_pages_urlnode_id" on
        table "fluent_pages_htmlpage_translation" DETAIL:  Key (id)=(2) is
        still referenced from table "fluent_pages_htmlpage_translation".
    """

    def setUp(self):
        self.site, __ = Site.objects.get_or_create(
            pk=1,
            defaults={'name': 'example.com', 'domain': 'example.com'})
        self.user_1 = G(User)
        self.layout = G(Layout)

        self.layoutpage = LayoutPage.objects.create(
            author=self.user_1,
            title='Test LayoutPage',
            layout=self.layout,
            #=================================================================
            # Trigger creation of SEO Translations on page where these
            # translations are related back to the proxy `HtmlPage` model.
            # This is what creates problematic DB relations fixed by the patch.
            #=================================================================
            meta_description='',
        )

    def tearDown(self):
        LayoutPage.objects.delete()

    # Test to trigger DB integrity errors if Fluent Page deletion is not
    # properly handled/patched
    def test_republish_page(self):
        # Publish first version
        self.layoutpage.publish()
        self.assertEqual(
            'Test LayoutPage', self.layoutpage.get_published().title)
        # Re-publish page, to trigger deletion and recreation of published
        # copy
        self.layoutpage.title += ' - Updated'
        self.layoutpage.save()
        self.layoutpage.publish()
        self.assertEqual(
            'Test LayoutPage - Updated',
            self.layoutpage.get_published().title)


class TestPublishingMiddleware(TestCase):

    def setUp(self):
        self.factory = RequestFactory()

        self.response = Mock()

        self.staff_1 = User.objects.create(
            username='staff_1',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        self.public_user = User.objects.create(
            username='public_user',
            is_active=True,
            is_staff=False,
            is_superuser=False,
        )

        self.reviewer_user = User.objects.create(
            username='reviewer',
            is_active=True,
            is_staff=False,
            is_superuser=False,
        )
        content_reviewers_group, __ = Group.objects.get_or_create(
            name='Content Reviewers')
        self.reviewer_user.groups.add(content_reviewers_group)

    def _request(self, path='/wherever/', data=None, user=None):
        request = self.factory.get(path, data)
        request.user = user or AnonymousUser()
        return request

    def test_middleware_method_is_admin_request(self):
        # Admin.
        request = self._request(reverse('admin:index'), user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_admin_request(request))
        # Not admin.
        request = self._request('/not-admin/', user=self.staff_1)
        self.assertFalse(PublishingMiddleware.is_admin_request(request))

    def test_middleware_method_is_staff_user(self):
        # Staff.
        request = self._request(user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_staff_user(request))
        # Reviewer.
        request = self._request(user=self.reviewer_user)
        self.assertFalse(PublishingMiddleware.is_staff_user(request))
        # Anonymous.
        self.assertFalse(
            PublishingMiddleware.is_staff_user(self._request()))

    def test_middleware_method_is_draft_request(self):
        # The `is_draft_request(request)` middleware method only checks if the
        # 'edit' flag is present in the querystring. So for content reviewers,
        # who *always* see draft content, their requests don't have the 'edit'
        # flag and so they will never be "draft requests". Confusingly, the
        # `is_draft(request)` is the one that determines the actual draft
        # status of a request!

        # Staff, with 'edit' flag.
        request = self._request(data={'edit': ''}, user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_draft_request(request))
        # Reviewer, with 'edit' flag.
        request = self._request(data={'edit': ''}, user=self.reviewer_user)
        self.assertTrue(PublishingMiddleware.is_draft_request(request))
        # Anonymous, with 'edit' flag.
        request = self._request(data={'edit': ''})
        self.assertTrue(PublishingMiddleware.is_draft_request(request))

        # Staff, without 'edit' flag.
        request = self._request(user=self.staff_1)
        self.assertFalse(PublishingMiddleware.is_draft_request(request))
        # Reviewer, without 'edit' flag.
        request = self._request(user=self.reviewer_user)
        self.assertFalse(PublishingMiddleware.is_draft_request(request))
        # Anonymous, without 'edit' flag.
        request = self._request()
        self.assertFalse(PublishingMiddleware.is_draft_request(request))

    def test_middleware_method_is_draft(self):
        # Admin requests are always draft.
        request = self._request(reverse('admin:index'), user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_draft(request))

        # Requests from content reviewers are draft, with the 'edit' flag...
        request = self._request(data={'edit': ''}, user=self.reviewer_user)
        self.assertTrue(PublishingMiddleware.is_draft(request))
        # ...and without.
        request = self._request(user=self.reviewer_user)
        self.assertTrue(PublishingMiddleware.is_draft(request))

        # Staff can request draft...
        request = self._request(data={'edit': ''}, user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_draft(request))
        # ...or published.
        request = self._request(user=self.staff_1)
        self.assertFalse(PublishingMiddleware.is_draft(request))

        # Draft flag is ignored for unprivileged users.
        request = self._request(data={'edit': ''}, user=self.public_user)
        self.assertFalse(PublishingMiddleware.is_draft(request))

        # Draft flag is honored for anonymous users if it has a valid draft
        # mode HMAC...
        request = self._request(
            '/', data={'edit': '%s:%s' % (1, get_draft_hmac(1, '/'))})
        self.assertTrue(PublishingMiddleware.is_draft(request))
        # ...and ignored if it is invalid.
        request = self._request('/', data={'edit': '1:abc'})
        self.assertFalse(PublishingMiddleware.is_draft(request))

    def test_middleware_active_status(self):
        mw = PublishingMiddleware()

        # Request processing sets middleware active flag
        mw.process_request(self._request())
        self.assertTrue(mw.is_publishing_middleware_active())
        self.assertTrue(is_publishing_middleware_active())

        # Response processing clears middleware active flag
        mw.process_response(self._request(), self.response)
        self.assertFalse(mw.is_publishing_middleware_active())
        self.assertFalse(is_publishing_middleware_active())

    def test_middleware_current_user(self):
        mw = PublishingMiddleware()

        # Request processing sets current user, AnonymousUser by default
        mw.process_request(self._request())
        self.assertTrue(mw.get_current_user().is_anonymous())
        self.assertTrue(get_current_user().is_anonymous())

        # Request processing sets current user when provided
        mw.process_request(self._request(user=self.reviewer_user))
        self.assertEqual(mw.get_current_user(), self.reviewer_user)
        self.assertEqual(get_current_user(), self.reviewer_user)

        # Test context manager override
        mw.process_request(self._request(user=self.reviewer_user))
        with override_current_user(AnonymousUser()):
            self.assertTrue(mw.get_current_user().is_anonymous())
            self.assertTrue(get_current_user().is_anonymous())

        # Response processing clears current user
        mw.process_response(self._request(), self.response)
        self.assertIsNone(mw.get_current_user())
        self.assertIsNone(get_current_user())

    def test_middleware_edit_param_triggers_draft_request_context(self):
        mw = PublishingMiddleware()

        # Request processing normal URL does not trigger draft status
        mw.process_request(self._request())
        self.assertFalse(mw.is_draft_request_context())
        self.assertFalse(is_draft_request_context())

        # Request URL from Content Reviewers is always draft, no 'edit' req'd
        request = self._request(user=self.reviewer_user)
        mw.process_request(request)
        self.assertTrue(mw.is_draft_request_context())
        self.assertTrue(is_draft_request_context())

        # Request URL with 'edit' param triggers draft for staff
        request = self._request(data={'edit': ''}, user=self.staff_1)
        mw.process_request(request)
        self.assertTrue(mw.is_draft_request_context())
        self.assertTrue(is_draft_request_context())

        # Non-privileged users cannot trigger draft mode with 'edit' param
        request = self._request(data={'edit': ''}, user=self.public_user)
        mw.process_request(self._request())
        self.assertFalse(mw.is_draft_request_context())
        self.assertFalse(is_draft_request_context())

        # Response processing clears draft status
        mw.process_response(self._request(), self.response)
        self.assertFalse(mw.is_draft_request_context())
        self.assertFalse(is_draft_request_context())

    def test_middleware_draft_view_sets_request_flag(self):
        mw = PublishingMiddleware()

        # Request normal URL sets IS_DRAFT to False
        request = self._request()
        mw.process_request(request)
        self.assertFalse(request.IS_DRAFT)

        # Request URL from Content Reviewer sets IS_DRAFT to True
        request = self._request(user=self.reviewer_user)
        mw.process_request(request)
        self.assertTrue(request.IS_DRAFT)

        # Request URL without param from staff sets IS_DRAFT to False
        request = self._request(user=self.staff_1)
        mw.process_request(request)
        self.assertFalse(request.IS_DRAFT)

        # Request URL with 'edit' param from staff sets IS_DRAFT to True
        request = self._request(
            '/',
            data={'edit': '%s:%s' % (1, get_draft_hmac(1, '/'))},
            user=self.staff_1,
        )
        mw.process_request(request)
        self.assertTrue(request.IS_DRAFT)

    def test_middleware_redirect_staff_to_draft_mode(self):
        # If staff use the 'edit' flag, it is automatically populated with a
        # valid draft mode HMAC, making the URL shareable.
        mw = PublishingMiddleware()

        # Empty 'edit' flag are populated.
        request = self._request(data={'edit': ''}, user=self.staff_1)
        response = mw.process_request(request)
        self.assertEqual(response.status_code, 302)
        self.assertTrue(verify_draft_url(response['Location']))

        # Invalid 'edit' flags are corrected.
        request = self._request(data={'edit': '1:abc'}, user=self.staff_1)
        response = mw.process_request(request)
        self.assertEqual(response.status_code, 302)
        self.assertTrue(verify_draft_url(response['Location']))

        # Non-ASCII query string values are supported by draft context URL
        # processing methods, so they don't raise "UnicodeEncodeError: 'ascii'
        # codec can't encode character..." exceptions when a unicode location
        # value is provided
        try:
            verify_draft_url(u"/search/?q=Eugène O'keeffe")
        except UnicodeEncodeError:
            self.fail("verify_draft_url mishandles non-ASCII unicode text")
        try:
            get_draft_url(u"/search/?q=Eugène O'keeffe")
        except UnicodeEncodeError:
            self.fail("get_draft_url mishandles non-ASCII unicode text")

    def test_middleware_redirect_staff_to_draft_view_on_404(self):
        mw = PublishingMiddleware()

        # 404 response for staff redirects to draft and retains GET params.
        request = self._request(data={'x': 'y', 'a': '432'}, user=self.staff_1)
        response = mw.process_response(request, HttpResponseNotFound())
        self.assertEqual(302, response.status_code)
        query = QueryDict(urlparse.urlparse(response['Location']).query)
        self.assertIn('edit', query)
        self.assertEqual(query['x'], 'y')
        self.assertEqual(query['a'], '432')

        # 404 response for draft view does not redirect
        request = self._request(data={'edit': ''}, user=self.staff_1)
        response = mw.process_response(request, HttpResponseNotFound())
        self.assertEqual(404, response.status_code)

        # 404 response for admin view does not redirect
        request = self._request(reverse('admin:index'), user=self.staff_1)
        response = mw.process_response(request, HttpResponseNotFound())
        self.assertEqual(404, response.status_code)

        # 404 response for content reviewer does not redirect, no point
        request = self._request(user=self.reviewer_user)
        response = mw.process_response(request, HttpResponseNotFound())
        self.assertEqual(404, response.status_code)

        # 404 response for general public does not redirect to draft view
        request = self._request(user=self.public_user)
        response = mw.process_response(request, HttpResponseNotFound())
        self.assertEqual(404, response.status_code)


class TestPublishingAdmin(BaseAdminTest):
    """
    Test publishing features via site admin.
    """

    def setUp(self):
        self.staff_1 = User.objects.create(
            username='staff_1',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        # Create initial publishable SlideShow
        self.slide_show_1 = SlideShow.objects.create(
            title='Test Slideshow',
        )

    def test_publish_slideshow(self):
        # Confirm slideshow is unpublished and versioned as such
        self.assertIsNone(self.slide_show_1.publishing_linked)

        # Check admin change page includes publish links, not unpublish ones
        response = self.app.get(
            reverse('admin:slideshow_slideshow_change',
                    args=(self.slide_show_1.pk, )),
            user=self.staff_1)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(
            reverse('admin:slideshow_slideshow_publish',
                    args=(self.slide_show_1.pk, )) in response.text)
        self.assertFalse(
            reverse('admin:slideshow_slideshow_unpublish',
                    args=(self.slide_show_1.pk, )) in response.text)

        # Publish via admin
        self.admin_publish_item(self.slide_show_1, user=self.staff_1)
        self.slide_show_1 = self.refresh(self.slide_show_1)
        self.assertIsNotNone(self.slide_show_1.publishing_linked)
        self.assertTrue(self.slide_show_1.has_been_published)
        self.assertTrue(self.slide_show_1.get_published().has_been_published)

        # Check admin change page includes unpublish link (published item)
        response = self.app.get(
            reverse('admin:slideshow_slideshow_change',
                    args=(self.slide_show_1.pk, )),
            user=self.staff_1)
        self.assertEqual(response.status_code, 200)
        self.assertFalse(
            reverse('admin:slideshow_slideshow_publish',
                    args=(self.slide_show_1.pk, )) in response.text)
        self.assertTrue(
            reverse('admin:slideshow_slideshow_unpublish',
                    args=(self.slide_show_1.pk, )) in response.text)

        # Publish again
        self.slide_show_1.title += ' - changed'
        self.slide_show_1.save()
        self.admin_publish_item(self.slide_show_1, user=self.staff_1)
        self.slide_show_1 = self.refresh(self.slide_show_1)

        # Unpublish via admin
        self.admin_unpublish_item(self.slide_show_1, user=self.staff_1)

        # New version has unpublished status
        self.slide_show_1 = self.refresh(self.slide_show_1)
        self.assertIsNone(self.slide_show_1.publishing_linked)
        self.assertFalse(self.slide_show_1.has_been_published)

        # Check admin change page includes publish links, not unpublish ones
        response = self.app.get(
            reverse('admin:slideshow_slideshow_change',
                    args=(self.slide_show_1.pk, )),
            user=self.staff_1)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(
            reverse('admin:slideshow_slideshow_publish',
                    args=(self.slide_show_1.pk, )) in response.text)
        self.assertFalse(
            reverse('admin:slideshow_slideshow_unpublish',
                    args=(self.slide_show_1.pk, )) in response.text)


@modify_settings(MIDDLEWARE_CLASSES={
    'append': 'icekit.publishing.middleware.PublishingMiddleware',
})
class TestPublishingForPageViews(WebTest):

    def setUp(self):
        self.normal_user = G(User)
        self.super_user = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )
        self.layout = G(
            Layout,
            template_name='icekit/layouts/default.html',
        )
        # LayoutPage is a PublishingModel
        self.layoutpage = LayoutPage.objects.create(
            author=self.super_user,
            title='Test LayoutPage',
            layout=self.layout,
        )
        self.content_instance = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage,
            html='<b>test content instance</b>'
        )
        # UnpublishableLayoutPage is not a PublishingModel
        self.unpublishablelayoutpage = UnpublishableLayoutPage.objects.create(
            author=self.super_user,
            title='Test Unpublishable LayoutPage',
            layout=self.layout,
            status=UrlNode.DRAFT,
        )
        self.content_instance = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.unpublishablelayoutpage,
            html='<b>test content instance</b>'
        )

    def test_verified_draft_url_for_publishingmodel(self):
        # Unpublished page is not visible to anonymous users
        response = self.app.get(
            self.layoutpage.get_absolute_url(),
            user=self.normal_user,
            expect_errors=True)
        self.assertEqual(response.status_code, 404)
        # Unpublished page is visible to staff user with '?edit' param redirect
        response = self.app.get(
            self.layoutpage.get_absolute_url(),
            user=self.super_user)
        self.assertEqual(response.status_code, 302)
        self.assertTrue('?edit=' in response['Location'])
        response = response.follow()
        self.assertEqual(response.status_code, 200)
        # Unpublished page is visible to any user with signed '?edit' param
        salt = '123'
        url_hmac = get_draft_hmac(salt, self.layoutpage.get_absolute_url())
        response = self.app.get(
            self.layoutpage.get_absolute_url() + '?edit=%s:%s' % (
                salt, url_hmac),
            user=self.normal_user)
        self.assertEqual(response.status_code, 200)

        # Publish page
        self.layoutpage.publish()

        # Published page is visible to anonymous users
        response = self.app.get(
            self.layoutpage.get_absolute_url(),
            user=self.normal_user)
        self.assertEqual(response.status_code, 200)

    # This is a duplicate of `test_verified_draft_url_for_publishingmodel` but
    # for a non-publishable model instead, to ensure verified draft URLs work
    # in all cases.
    def test_verified_draft_url_for_non_publishingmodel(self):
        # Unpublished page is not visible to anonymous users
        response = self.app.get(
            self.unpublishablelayoutpage.get_absolute_url(),
            user=self.normal_user,
            expect_errors=True)
        self.assertEqual(response.status_code, 404)
        # Unpublished page is visible to staff user with '?edit' param redirect
        response = self.app.get(
            self.unpublishablelayoutpage.get_absolute_url(),
            user=self.super_user)
        self.assertEqual(response.status_code, 302)
        self.assertTrue('?edit=' in response['Location'])
        response = response.follow()
        self.assertEqual(response.status_code, 200)
        # Unpublished page is visible to any user with signed '?edit' param
        salt = '123'
        url_hmac = get_draft_hmac(salt, self.unpublishablelayoutpage.get_absolute_url())
        response = self.app.get(
            self.unpublishablelayoutpage.get_absolute_url() + '?edit=%s:%s' % (
                salt, url_hmac),
            user=self.normal_user)
        self.assertEqual(response.status_code, 200)

        # Publish page by changing status (no `published()` method)
        self.unpublishablelayoutpage.status = UrlNode.PUBLISHED
        self.unpublishablelayoutpage.save()

        # Published page is visible to anonymous users
        response = self.app.get(
            self.unpublishablelayoutpage.get_absolute_url(),
            user=self.normal_user)
        self.assertEqual(response.status_code, 200)


class TestPublishingOfM2MRelationships(TestCase):
    """ Test publishing works correctly with complex M2M relationships """

    def setUp(self):
        self.skipTest("Complex M2M relationships not yet present in ICEKit")

    # TODO Add test_m2m_handling_in_publishing_clone_relations from SFMOMA

    # TODO Add test_contentitem_m2m_backrefs_maintained_on_publish from SFMOMA
