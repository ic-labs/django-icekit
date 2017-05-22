# -*- coding: utf-8 -*-
from datetime import timedelta
import urlparse

from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.models import AnonymousUser, Group, Permission
from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.core.urlresolvers import reverse
from django.http import HttpResponseNotFound, QueryDict
from django.test import TestCase, TransactionTestCase, RequestFactory
from django.test.utils import override_settings, modify_settings
from django.utils import timezone

from mock import patch, Mock

from django_dynamic_fixture import G

from fluent_contents.plugins.rawhtml.models import RawHtmlItem
from fluent_contents.models import Placeholder

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
    Article, ArticleListing, PublishingM2MModelA, \
    PublishingM2MModelB, PublishingM2MThroughTable

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
        self.staff_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        # Create initial publishable SlideShow, a simple publishable model
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
        self.assertEqual(
            self.slide_show_1,
            self.slide_show_1.publishing_linked.publishing_draft.get_draft())
        # Ensure raw `publishing_draft` relationship also returns plain draft
        self.assertEqual(
            self.slide_show_1,
            self.slide_show_1.publishing_linked.publishing_draft)

        # get_draft always returns the unwrapped draft
        # TODO Beware, these tests never triggered actual failure case, and
        # should be unnecessary given the model equality tests above
        self.assertFalse(isinstance(self.slide_show_1.get_draft(), DraftItemBoobyTrap))
        self.assertFalse(isinstance(self.slide_show_1.publishing_linked.get_draft(), DraftItemBoobyTrap))
        self.assertFalse(isinstance(self.slide_show_1.publishing_linked.publishing_draft.get_draft(), DraftItemBoobyTrap))

    def test_model_get_published(self):
        self.assertIsNone(self.slide_show_1.get_published())
        self.slide_show_1.publish()
        self.assertEqual(
            self.slide_show_1.publishing_linked,
            self.slide_show_1.get_published())
        self.assertEqual(
            self.slide_show_1.publishing_linked,
            self.slide_show_1.publishing_linked.get_published())


class TestPublishableFluentContentsPage(TestCase):
    """ Test publishing features with a Fluent Contents Page """

    def setUp(self):
        self.site, __ = Site.objects.get_or_create(
            pk=1,
            defaults={'name': 'example.com', 'domain': 'example.com'})

        self.user_1 = G(User)
        self.staff_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        self.page_layout_1 = G(Layout)
        self.fluent_page = LayoutPage.objects.create(
            author=self.user_1,
            title='Test title',
            layout=self.page_layout_1,
        )
        self.placeholder = Placeholder.objects.create_for_object(
            self.fluent_page,
            slot='test-slot',
            role='t',
            title='Test Placeholder',
        )

    def test_contentitems_and_placeholders_cloned_on_publish(self):
        # Associate content items with page
        item_1 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.fluent_page,
            placeholder_name='test-slot',
            html='<b>rawhtmlitem 1</b>'
        )
        item_2 = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.fluent_page,
            placeholder_name='test-slot',
            html='<b>rawhtmlitem 2</b>'
        )
        self.assertEqual(
            2, self.fluent_page.contentitem_set.count())
        self.assertEqual(
            list(self.fluent_page.contentitem_set.all()),
            [item_1, item_2])
        self.assertEqual(
            [i.html for i in self.fluent_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder for i in self.fluent_page.contentitem_set.all()],
            [self.placeholder, self.placeholder])
        self.assertEqual(
            [i.placeholder.slot
             for i in self.fluent_page.contentitem_set.all()],
            ['test-slot', 'test-slot'])
        # Publish page
        self.fluent_page.publish()
        published_page = self.fluent_page.publishing_linked
        self.assertNotEqual(
            self.fluent_page.pk, published_page.pk)
        # Confirm published page has cloned content items and placeholders
        # (with different model instances (PKs) but same content)
        self.assertEqual(
            2, published_page.contentitem_set.count())
        self.assertNotEqual(
            list(published_page.contentitem_set.all()),
            [item_1, item_2])
        self.assertEqual(
            [i.html for i in published_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1</b>', '<b>rawhtmlitem 2</b>'])
        self.assertNotEqual(
            [i.placeholder for i in published_page.contentitem_set.all()],
            [self.placeholder, self.placeholder])
        self.assertEqual(
            [i.placeholder.slot
             for i in published_page.contentitem_set.all()],
            ['test-slot', 'test-slot'])
        # Modify content items and placeholders for draft page
        item_1.html = '<b>rawhtmlitem 1 - updated</b>'
        item_1.save()
        self.placeholder.slot = 'test-slot-updated'
        self.placeholder.save()
        self.fluent_page.save()  # Trigger timestamp change in draft page
        self.assertEqual(
            [i.html for i in self.fluent_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1 - updated</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder.slot
             for i in self.fluent_page.contentitem_set.all()],
            ['test-slot-updated', 'test-slot-updated'])
        # Confirm content items for published copy remain unchanged
        published_page = self.fluent_page.publishing_linked
        self.assertEqual(
            [i.html for i in published_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder.slot
             for i in published_page.contentitem_set.all()],
            ['test-slot', 'test-slot'])
        # Re-publish page
        self.fluent_page.publish()
        published_page = self.fluent_page.publishing_linked
        # Confirm published page has updated content items
        self.assertEqual(
            [i.html for i in published_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1 - updated</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder.slot
             for i in published_page.contentitem_set.all()],
            ['test-slot-updated', 'test-slot-updated'])

    def test_model_is_within_publication_dates(self):
        # Empty publication start/end dates
        self.assertTrue(self.fluent_page.is_within_publication_dates())
        # Test publication start date
        self.fluent_page.publication_date = timezone.now() - timedelta(seconds=1)
        self.fluent_page.save()
        self.assertTrue(self.fluent_page.is_within_publication_dates())
        self.fluent_page.publication_date = timezone.now() + timedelta(seconds=1)
        self.fluent_page.save()
        self.assertFalse(self.fluent_page.is_within_publication_dates())
        # Reset
        self.fluent_page.publication_date = None
        self.fluent_page.save()
        self.assertTrue(self.fluent_page.is_within_publication_dates())
        # Test publication end date
        self.fluent_page.publication_end_date = \
            timezone.now() + timedelta(seconds=1)
        self.fluent_page.save()
        self.assertTrue(self.fluent_page.is_within_publication_dates())
        self.fluent_page.publication_end_date = \
            timezone.now() - timedelta(seconds=1)
        self.fluent_page.save()
        self.assertFalse(self.fluent_page.is_within_publication_dates())
        # Reset
        self.fluent_page.publication_end_date = None
        self.fluent_page.save()
        self.assertTrue(self.fluent_page.is_within_publication_dates())
        # Test both publication start and end dates against arbitrary timestamp
        self.fluent_page.publication_date = timezone.now() - timedelta(seconds=1)
        self.fluent_page.publication_end_date = \
            timezone.now() + timedelta(seconds=1)
        self.assertTrue(self.fluent_page.is_within_publication_dates())
        self.assertTrue(
            self.fluent_page.is_within_publication_dates(timezone.now()))
        # Timestamp exactly at publication start date is acceptable
        self.assertTrue(
            self.fluent_page.is_within_publication_dates(
                self.fluent_page.publication_date))
        # Timestamp exactly at publication end date is not acceptable
        self.assertFalse(
            self.fluent_page.is_within_publication_dates(
                self.fluent_page.publication_end_date))

    def test_queryset_published_with_urlnode_based_publishing_model(self):
        self.assertEqual(
            [], list(LayoutPage.objects.published()))
        self.fluent_page.publish()
        # Return only published items
        self.assertEqual(
            [self.fluent_page.publishing_linked],  # Compare published copy
            list(LayoutPage.objects.published()))
        # Confirm we only get published items regardless of
        # `is_draft_request_context`
        with patch('icekit.publishing.apps.is_draft_request_context') as p:
            p.return_value = True
            self.assertEqual(
                [self.fluent_page.publishing_linked],
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
        self.fluent_page.unpublish()
        self.assertEqual(
            set([]), set(LayoutPage.objects.published()))
        # ... but exchange can be forced
        self.fluent_page.publish()
        self.assertEqual(
            set([self.fluent_page.publishing_linked]),
            set(LayoutPage.objects.published(force_exchange=True)))

    def test_urlnodequerysetwithpublishingfeatures_for_publishing_model(self):
        # Create page with related pages relationships to Fluent Page
        test_page = LayoutPageWithRelatedPages.objects.create(
            author=self.user_1,
            title='Test Page',
            layout=self.page_layout_1,
        )
        test_page.related_pages.add(self.fluent_page)
        self.fluent_page.publish()
        self.assertEqual(
            set([self.fluent_page]),
            set(test_page.related_pages.all()))
        # Confirm relationship queryset is monkey-patched
        self.assertEqual(
            UrlNodeQuerySetWithPublishingFeatures,
            type(test_page.related_pages.all()))
        # Published -- exchange of draft-to-published items by default
        self.assertEqual(
            set([self.fluent_page.get_published()]),
            set(test_page.related_pages.published()))
        # Published -- exchange of draft-to-published items can be disabled
        self.assertEqual(
            set([]),
            set(test_page.related_pages.published(force_exchange=False)))
        # Draft
        self.assertEqual(
            set([self.fluent_page]),
            set(test_page.related_pages.draft()))
        # Visible - published items unless we are in privileged context
        self.assertEqual(
            set([self.fluent_page.get_published()]),
            set(test_page.related_pages.visible()))
        with override_draft_request_context(True):
            self.assertEqual(
                set([self.fluent_page]),
                set(test_page.related_pages.visible()))

    def test_fluent_page_model_get_draft(self):
        self.fluent_page.publish()
        self.assertEqual(
            self.fluent_page, self.fluent_page.get_draft())
        self.assertEqual(
            self.fluent_page, self.fluent_page.publishing_linked.get_draft())
        self.assertEqual(
            self.fluent_page,
            self.fluent_page.publishing_linked.publishing_draft.get_draft())
        # Ensure raw `publishing_draft` relationship also returns plain draft
        self.assertEqual(
            self.fluent_page,
            self.fluent_page.publishing_linked.publishing_draft)


class TestPublishableFluentContents(TestCase):
    """ Test publishing features with a Fluent Contents item (not a page) """

    def setUp(self):
        self.site, __ = Site.objects.get_or_create(
            pk=1,
            defaults={'name': 'example.com', 'domain': 'example.com'})

        self.user_1 = G(User)
        self.staff_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        self.page_layout_1 = G(Layout)

        self.listing = ArticleListing.objects.create(
            author=self.staff_1,
            title="Listing Test",
            slug="listing-test",
            layout=self.page_layout_1,
        )
        self.fluent_contents = Article.objects.create(
            title='Test title',
            layout=self.page_layout_1,
            parent=self.listing,
        )
        self.placeholder = Placeholder.objects.create_for_object(
            self.fluent_contents,
            slot='test-slot',
            role='t',
            title='Test Placeholder',
        )

    def test_contentitems_and_placeholders_cloned_on_publish(self):
        # Associate content items with page
        article_ct = ContentType.objects.get_for_model(Article)
        item_1 = RawHtmlItem.objects.create(
            parent_type=article_ct,
            parent_id=self.fluent_contents.id,
            placeholder=self.placeholder,
            html='<b>rawhtmlitem 1</b>'
        )
        item_2 = RawHtmlItem.objects.create(
            parent_type=article_ct,
            parent_id=self.fluent_contents.id,
            placeholder=self.placeholder,
            html='<b>rawhtmlitem 2</b>'
        )
        self.assertEqual(
            2, self.fluent_contents.contentitem_set.count())
        self.assertEqual(
            list(self.fluent_contents.contentitem_set.all()),
            [item_1, item_2])
        self.assertEqual(
            [i.html for i in self.fluent_contents.contentitem_set.all()],
            ['<b>rawhtmlitem 1</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder for i in self.fluent_contents.contentitem_set.all()],
            [self.placeholder, self.placeholder])
        self.assertEqual(
            [i.placeholder.slot
             for i in self.fluent_contents.contentitem_set.all()],
            ['test-slot', 'test-slot'])
        # Publish page
        self.fluent_contents.publish()
        published_page = self.fluent_contents.publishing_linked
        self.assertNotEqual(
            self.fluent_contents.pk, published_page.pk)
        # Confirm published page has cloned content items and placeholders
        # (with different model instances (PKs) but same content)
        self.assertEqual(
            2, published_page.contentitem_set.count())
        self.assertNotEqual(
            list(published_page.contentitem_set.all()),
            [item_1, item_2])
        self.assertEqual(
            [i.html for i in published_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1</b>', '<b>rawhtmlitem 2</b>'])
        self.assertNotEqual(
            [i.placeholder for i in published_page.contentitem_set.all()],
            [self.placeholder, self.placeholder])
        self.assertEqual(
            [i.placeholder.slot
             for i in published_page.contentitem_set.all()],
            ['test-slot', 'test-slot'])
        # Modify content items and placeholders for draft page
        item_1.html = '<b>rawhtmlitem 1 - updated</b>'
        item_1.save()
        self.placeholder.slot = 'test-slot-updated'
        self.placeholder.save()
        self.fluent_contents.save()  # Trigger timestamp change in draft page
        self.assertEqual(
            [i.html for i in self.fluent_contents.contentitem_set.all()],
            ['<b>rawhtmlitem 1 - updated</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder.slot
             for i in self.fluent_contents.contentitem_set.all()],
            ['test-slot-updated', 'test-slot-updated'])
        # Confirm content items for published copy remain unchanged
        published_page = self.fluent_contents.publishing_linked
        self.assertEqual(
            [i.html for i in published_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder.slot
             for i in published_page.contentitem_set.all()],
            ['test-slot', 'test-slot'])
        # Re-publish page
        self.fluent_contents.publish()
        published_page = self.fluent_contents.publishing_linked
        # Confirm published page has updated content items
        self.assertEqual(
            [i.html for i in published_page.contentitem_set.all()],
            ['<b>rawhtmlitem 1 - updated</b>', '<b>rawhtmlitem 2</b>'])
        self.assertEqual(
            [i.placeholder.slot
             for i in published_page.contentitem_set.all()],
            ['test-slot-updated', 'test-slot-updated'])


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
    # Set `available_apps` here merely to trigger special behaviour in
    # `TransactionTestCase._fixture_teardown` to avoid emitting the
    # `post_migrate` signal when flushing the DB during teardown, since doing
    # so can cause integrity errors related to publishing-related permissions
    # created by icekit.publishing.models.create_can_publish_permission
    available_apps = settings.INSTALLED_APPS

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
        LayoutPage.objects.all().delete()

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

        self.staff_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        self.public_user = G(
            User,
            is_active=True,
            is_staff=False,
            is_superuser=False,
        )

        self.reviewer_user = G(
            User,
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
        # 'preview' flag is present in the querystring. So for content
        # reviewers, who *always* see draft content, their requests don't have
        # the 'preview' flag and so they will never be "draft requests".
        # Confusingly, the `is_draft(request)` is the one that determines the
        # actual draft status of a request!

        # Staff, with 'preview' flag.
        request = self._request(data={'preview': ''}, user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_draft_request(request))
        # Reviewer, with 'preview' flag.
        request = self._request(data={'preview': ''}, user=self.reviewer_user)
        self.assertTrue(PublishingMiddleware.is_draft_request(request))
        # Anonymous, with 'preview' flag.
        request = self._request(data={'preview': ''})
        self.assertTrue(PublishingMiddleware.is_draft_request(request))

        # Staff, without 'preview' flag.
        request = self._request(user=self.staff_1)
        self.assertFalse(PublishingMiddleware.is_draft_request(request))
        # Reviewer, without 'preview' flag.
        request = self._request(user=self.reviewer_user)
        self.assertFalse(PublishingMiddleware.is_draft_request(request))
        # Anonymous, without 'preview' flag.
        request = self._request()
        self.assertFalse(PublishingMiddleware.is_draft_request(request))

    def test_middleware_method_is_draft(self):
        # Admin requests are always draft.
        request = self._request(reverse('admin:index'), user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_draft(request))

        # Requests from content reviewers are draft, with the 'preview' flag...
        request = self._request(data={'preview': ''}, user=self.reviewer_user)
        self.assertTrue(PublishingMiddleware.is_draft(request))
        # ...and without.
        request = self._request(user=self.reviewer_user)
        self.assertTrue(PublishingMiddleware.is_draft(request))

        # Staff can request draft...
        request = self._request(data={'preview': ''}, user=self.staff_1)
        self.assertTrue(PublishingMiddleware.is_draft(request))
        # ...or published.
        request = self._request(user=self.staff_1)
        self.assertFalse(PublishingMiddleware.is_draft(request))

        # Draft flag is ignored for unprivileged users.
        request = self._request(data={'preview': ''}, user=self.public_user)
        self.assertFalse(PublishingMiddleware.is_draft(request))

        # Draft flag is honored for anonymous users if it has a valid draft
        # mode HMAC...
        request = self._request(
            '/', data={'preview': '%s:%s' % (1, get_draft_hmac(1, '/'))})
        self.assertTrue(PublishingMiddleware.is_draft(request))
        # ...and ignored if it is invalid.
        request = self._request('/', data={'preview': '1:abc'})
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

    def test_middleware_preview_param_triggers_draft_request_context(self):
        mw = PublishingMiddleware()

        # Request processing normal URL does not trigger draft status
        mw.process_request(self._request())
        self.assertFalse(mw.is_draft_request_context())
        self.assertFalse(is_draft_request_context())

        # Request URL from Content Reviewers is always draft, no 'preview' req'd
        request = self._request(user=self.reviewer_user)
        mw.process_request(request)
        self.assertTrue(mw.is_draft_request_context())
        self.assertTrue(is_draft_request_context())

        # Request URL with 'preview' param triggers draft for staff
        request = self._request(data={'preview': ''}, user=self.staff_1)
        mw.process_request(request)
        self.assertTrue(mw.is_draft_request_context())
        self.assertTrue(is_draft_request_context())

        # Non-privileged users cannot trigger draft mode with 'preview' param
        request = self._request(data={'preview': ''}, user=self.public_user)
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

        # Request URL with 'preview' param from staff sets IS_DRAFT to True
        request = self._request(
            '/',
            data={'preview': '%s:%s' % (1, get_draft_hmac(1, '/'))},
            user=self.staff_1,
        )
        mw.process_request(request)
        self.assertTrue(request.IS_DRAFT)

    def test_middleware_redirect_staff_to_draft_mode(self):
        # If staff use the 'preview' flag, it is automatically populated with a
        # valid draft mode HMAC, making the URL shareable.
        mw = PublishingMiddleware()

        # Empty 'preview' flag are populated.
        request = self._request(data={'preview': ''}, user=self.staff_1)
        response = mw.process_request(request)
        self.assertEqual(response.status_code, 302)
        self.assertTrue(verify_draft_url(response['Location']))

        # Invalid 'preview' flags are corrected.
        request = self._request(data={'preview': '1:abc'}, user=self.staff_1)
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
        self.assertIn('preview', query)
        self.assertEqual(query['x'], 'y')
        self.assertEqual(query['a'], '432')

        # 404 response for draft view does not redirect
        request = self._request(data={'preview': ''}, user=self.staff_1)
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


class TestPublishingAdminForSlideShow(BaseAdminTest):
    """
    Test publishing features in site admin for SlideShow publishable item
    """

    def setUp(self):
        self.staff_1 = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        # Create initial publishable SlideShow
        self.slide_show_1 = SlideShow.objects.create(
            title='Test Slideshow',
        )

        # Fetch permissions to test
        slideshow_ct = ContentType.objects.get_for_model(self.slide_show_1)
        self.change_slideshow_permission = Permission.objects.get(
            content_type=slideshow_ct, codename='change_slideshow')
        self.can_publish_permission = Permission.objects.get(
            content_type=slideshow_ct, codename='can_publish')
        self.can_republish_permission = Permission.objects.get(
            content_type=slideshow_ct, codename='can_republish')

        # Generate URL paths/links to test
        self.admin_list_page_url = reverse(
            'admin:icekit_plugins_slideshow_slideshow_changelist')
        self.admin_change_page_url = reverse(
            'admin:icekit_plugins_slideshow_slideshow_change',
            args=(self.slide_show_1.pk, ))
        self.publish_link = reverse(
            'admin:icekit_plugins_slideshow_slideshow_publish',
            args=(self.slide_show_1.pk, ))
        self.unpublish_link = reverse(
            'admin:icekit_plugins_slideshow_slideshow_unpublish',
            args=(self.slide_show_1.pk, ))

    def test_publish_slideshow(self):
        # Confirm slideshow is unpublished and versioned as such
        self.assertIsNone(self.slide_show_1.publishing_linked)

        # Check admin change page includes publish links, not unpublish ones
        response = self.app.get(
            self.admin_change_page_url,
            user=self.staff_1)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(self.publish_link in response.text)
        self.assertFalse(self.unpublish_link in response.text)

        # Publish via admin
        self.admin_publish_item(self.slide_show_1, user=self.staff_1)
        self.slide_show_1 = self.refresh(self.slide_show_1)
        self.assertIsNotNone(self.slide_show_1.publishing_linked)
        self.assertTrue(self.slide_show_1.has_been_published)
        self.assertTrue(self.slide_show_1.get_published().has_been_published)

        # Check admin change page includes unpublish link (published item)
        response = self.app.get(
            self.admin_change_page_url,
            user=self.staff_1)
        self.assertEqual(response.status_code, 200)
        self.assertFalse(self.publish_link in response.text)
        self.assertTrue(self.unpublish_link in response.text)

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
            self.admin_change_page_url,
            user=self.staff_1)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(self.publish_link in response.text)
        self.assertFalse(self.unpublish_link in response.text)

    def test_bulk_publishing_action_respects_permissions(self):
        # Normal user with change permission but without publishing permissions
        user = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=False,
        )
        user.user_permissions = [self.change_slideshow_permission]

        # Set up one already-published but dirty slideshow, one unpublished
        self.slide_show_1.publish()
        self.slide_show_1.title += ' (updated)'
        self.slide_show_1.save()
        self.slide_show_1 = self.refresh(self.slide_show_1)
        self.assertTrue(self.slide_show_1.is_dirty)

        slide_show_2 = SlideShow.objects.create(
            title='Test Slideshow',
        )

        # User without publishing permissions performs 'publish' action
        response = self.app.get(self.admin_list_page_url, user=user)
        form = response.forms['changelist-form']
        form['action'].value = 'publish'
        for item_to_action_checkbox in form.fields['_selected_action']:
            item_to_action_checkbox.checked = True
        response = form.submit('index', user=user).follow()
        self.assertEqual(response.status_code, 200)

        # Confirm nothing has actually been (re)published
        self.assertTrue(self.slide_show_1.is_dirty)
        self.assertFalse(slide_show_2.has_been_published)

        # User with only `can_republish` permission performs 'publish' action
        user.user_permissions = \
            [self.change_slideshow_permission, self.can_republish_permission]
        response = form.submit('index', user=user).follow()
        self.assertEqual(response.status_code, 200)

        # Confirm already published item is republished, unpublished item isn't
        self.slide_show_1 = self.refresh(self.slide_show_1)
        slide_show_2 = self.refresh(slide_show_2)
        self.assertFalse(self.slide_show_1.is_dirty)
        self.assertFalse(slide_show_2.has_been_published)

        # Re-dirty slideshow 1
        self.slide_show_1.title += ' (updated again)'
        self.slide_show_1.save()
        self.slide_show_1 = self.refresh(self.slide_show_1)
        self.assertTrue(self.slide_show_1.is_dirty)

        # User with `can_publish` permission performs 'publish' action
        user.user_permissions = \
            [self.change_slideshow_permission, self.can_publish_permission]
        response = form.submit('index', user=user).follow()
        self.assertEqual(response.status_code, 200)

        # Confirm already published and unpublished items are both published
        self.slide_show_1 = self.refresh(self.slide_show_1)
        slide_show_2 = self.refresh(slide_show_2)
        self.assertFalse(self.slide_show_1.is_dirty)
        self.assertTrue(self.slide_show_1.has_been_published)
        self.assertTrue(slide_show_2.has_been_published)

    def test_user_publishing_permissions(self):
        # Normal user with change permission but without publishing permissions
        user = G(
            User,
            is_staff=True,
            is_active=True,
            is_superuser=False,
        )
        user.user_permissions = [self.change_slideshow_permission]

        # Publish slideshow, to make unpublish link available for testing
        self.slide_show_1.publish()
        # Update draft slideshow, to make publish link available for testing
        self.slide_show_1.title += ' (updated)'
        self.slide_show_1.save()

        # Check admin change page does not include publish or unpublish links
        # for user with no publishing permissions
        response = self.app.get(self.admin_change_page_url, user=user)
        self.assertEqual(response.status_code, 200)
        self.assertFalse(self.publish_link in response.text)
        self.assertFalse(self.unpublish_link in response.text)
        # Confirm user cannot perform publish/unpublish actions
        self.app.get(self.publish_link, user=user, status=403)
        self.app.get(self.unpublish_link, user=user, status=403)

        # Check admin change page does include publish and unpublish links for
        # user with `can_publish` permission
        user.user_permissions = \
            [self.change_slideshow_permission, self.can_publish_permission]
        response = self.app.get(self.admin_change_page_url, user=user)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(self.publish_link in response.text)
        self.assertTrue(self.unpublish_link in response.text)

        # Check admin change page does include publish and unpublish links
        # for user with only `can_republish` publishing permissions when item
        # is already published
        user.user_permissions = \
            [self.change_slideshow_permission, self.can_republish_permission]
        response = self.app.get(self.admin_change_page_url, user=user)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(self.publish_link in response.text)
        self.assertTrue(self.unpublish_link in response.text)

        # Check admin change page does not include publish or unpublish links
        # for user with only `can_republish` publishing permissions if item
        # is not already published
        self.slide_show_1.unpublish()
        user.user_permissions = \
            [self.change_slideshow_permission, self.can_republish_permission]
        response = self.app.get(self.admin_change_page_url, user=user)
        self.assertEqual(response.status_code, 200)
        self.assertFalse(self.publish_link in response.text)
        self.assertFalse(self.unpublish_link in response.text)
        # Confirm user cannot perform publish/unpublish actions
        self.app.get(self.publish_link, user=user, status=403)
        self.app.get(self.unpublish_link, user=user, status=403)


class TestPublishingAdminForLayoutPage(BaseAdminTest):
    """
    Test publishing features in site admin for LayoutPage publishable item
    """

    def setUp(self):
        self.ct = self.ct_for_model(LayoutPage)
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
            slug='test-layoutpage',
            layout=self.layout,
        )
        self.layout.content_types.add(self.ct)

        # Generate URL paths/links to test
        self.admin_add_page_url = reverse(
            'admin:layout_page_layoutpage_add')
        self.admin_change_page_url = reverse(
            'admin:layout_page_layoutpage_change',
            args=(self.layoutpage.pk, ))

    def test_admin_monkey_patch_slug_duplicates(self):
        # Test our monkey patch works to fix duplicate `slug` field errors
        # caused by draft and published copies of the same item sharing a slug.

        # Confirm we have a draft publishable item that has a slug field
        self.assertEqual('test-layoutpage', self.layoutpage.slug)
        self.assertIsNone(self.layoutpage.publishing_linked)

        # Publish item via admin with same slug
        self.admin_publish_item(self.layoutpage, user=self.super_user)
        self.layoutpage = self.refresh(self.layoutpage)
        self.assertIsNotNone(self.layoutpage.publishing_linked)
        self.assertEqual(
            'test-layoutpage', self.layoutpage.get_published().slug)

        # Confirm we can update draft version via admin with shared slug
        response = self.app.get(
            self.admin_change_page_url,
            user=self.super_user)
        self.assertEqual(response.status_code, 200)
        form = response.forms['layoutpage_form']
        form['title'].value = 'Test LayoutPage Updated'
        response = form.submit('_continue', user=self.super_user)
        self.assertFalse(
            'This slug is already used by an other page at the same level'
            in response.content)
        self.layoutpage = self.refresh(self.layoutpage)
        self.assertEqual('test-layoutpage', self.layoutpage.slug)
        self.assertEqual('Test LayoutPage Updated', self.layoutpage.title)

        # Confirm we can re-publish draft version via admin with shared slug
        self.admin_publish_item(self.layoutpage, user=self.super_user)
        self.layoutpage = self.refresh(self.layoutpage)
        self.assertIsNotNone(self.layoutpage.publishing_linked)
        self.assertEqual(
            'test-layoutpage', self.layoutpage.get_published().slug)
        self.assertEqual(
            'Test LayoutPage Updated', self.layoutpage.get_published().title)

        # Confirm we cannot create a different item via admin with same slug
        response = self.app.get(
            self.admin_add_page_url,
            user=self.super_user)
        form = response.forms['page_form']
        form['ct_id'].select(self.ct.pk)  # Choose LayoutPage page type
        response = form.submit(user=self.super_user).follow()
        self.assertFalse('error' in response.content)
        form = response.forms['layoutpage_form']
        form['layout'].select(self.layout.pk)
        form['title'] = 'Another Page'
        form['slug'] = self.layoutpage.slug  # Same slug as existing page
        response = form.submit('_continue', user=self.super_user)
        self.assertTrue(
            'This slug is already used by an other page at the same level'
            in response.content)

    def test_admin_monkey_patch_override_url_duplicates(self):
        # Test our monkey patch works to fix duplicate `override_url` field
        # errors caused by draft and published copies of the same item sharing
        # an override URL.

        # Add override URL to item
        self.layoutpage.override_url = '/'
        self.layoutpage.save()

        # Publish item via admin with same override URL
        self.admin_publish_item(self.layoutpage, user=self.super_user)
        self.layoutpage = self.refresh(self.layoutpage)
        self.assertIsNotNone(self.layoutpage.publishing_linked)
        self.assertEqual(
            '/', self.layoutpage.get_published().override_url)

        # Confirm we can update draft version via admin with same override URL
        response = self.app.get(
            self.admin_change_page_url,
            user=self.super_user)
        self.assertEqual(response.status_code, 200)
        form = response.forms['layoutpage_form']
        form['title'].value = 'Test LayoutPage Updated'
        response = form.submit('_continue', user=self.super_user)
        self.assertFalse(
            'This URL is already taken by an other page.'
            in response.content)
        self.layoutpage = self.refresh(self.layoutpage)
        self.assertEqual('/', self.layoutpage.override_url)
        self.assertEqual('Test LayoutPage Updated', self.layoutpage.title)

        # Confirm we can re-publish draft version via admin with same override
        self.admin_publish_item(self.layoutpage, user=self.super_user)
        self.layoutpage = self.refresh(self.layoutpage)
        self.assertIsNotNone(self.layoutpage.publishing_linked)
        self.assertEqual(
            '/', self.layoutpage.get_published().override_url)
        self.assertEqual(
            'Test LayoutPage Updated', self.layoutpage.get_published().title)

        # Confirm we cannot create a different item via admin with same
        # override URL
        response = self.app.get(
            self.admin_add_page_url,
            user=self.super_user)
        form = response.forms['page_form']
        form['ct_id'].select(self.ct.pk)  # Choose LayoutPage page type
        response = form.submit(user=self.super_user).follow()
        self.assertFalse('error' in response.content)
        form = response.forms['layoutpage_form']
        form['layout'].select(self.layout.pk)
        form['title'] = 'Another Page'
        form['slug'] = 'another-page'
        form['override_url'] = self.layoutpage.override_url  # Same override
        response = form.submit('_continue', user=self.super_user)
        self.assertTrue(
            'This URL is already taken by an other page.'
            in response.content)


@modify_settings(MIDDLEWARE_CLASSES={
    'append': 'icekit.publishing.middleware.PublishingMiddleware',
})
class TestPublishingForPageViews(BaseAdminTest):

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
            slug='test-layoutpage',
            layout=self.layout,
        )
        self.content_instance = fluent_contents.create_content_instance(
            RawHtmlItem,
            self.layoutpage,
            html='<b>test content instance</b>'
        )

    def test_url_routing_for_draft_and_published_copies(self):
        # Unpublished page is not visible to anonymous users
        response = self.app.get('/test-layoutpage/', expect_errors=True)
        self.assertEqual(response.status_code, 404)
        # Unpublished page is visible to staff user with '?preview' param redirect
        response = self.app.get(
            '/test-layoutpage/',
            user=self.super_user,
        ).follow()
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Test LayoutPage')

        # Publish page
        self.layoutpage.publish()
        self.assertEqual(
            '/test-layoutpage/',
            self.layoutpage.get_published().get_absolute_url())

        # Published page is visible to anonymous users
        response = self.app.get('/test-layoutpage/')
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Test LayoutPage')

        # Change Title and slug (URL) of draft page
        self.layoutpage.title = 'Updated LayoutPage'
        self.layoutpage.slug = 'updated-layoutpage'
        self.layoutpage.save()
        self.layoutpage = self.refresh(self.layoutpage)
        self.assertEqual(
            '/updated-layoutpage/', self.layoutpage.get_absolute_url())

        # URL of published page remains unchanged
        self.assertEqual(
            '/test-layoutpage/',
            self.layoutpage.get_published().get_absolute_url())

        # Published page is at unchanged URL
        response = self.app.get('/test-layoutpage/')
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Test LayoutPage')

        # Draft page is at changed URL
        response = self.app.get(
            '/updated-layoutpage/',
            user=self.super_user,
        ).follow()
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Updated LayoutPage')

        # Draft page is visible at changed URL via ?preview URL
        response = self.app.get(
            '/updated-layoutpage/?preview',
            user=self.super_user,
        ).follow()
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Updated LayoutPage')

        # Draft page is *not* visible at ?preview URL of old (published page) URL
        response = self.app.get(
            '/test-layoutpage/?preview',
            user=self.super_user,
        )
        self.assertEqual(response.status_code, 302)
        response = response.follow(expect_errors=True)
        self.assertEqual(response.status_code, 404)

    def test_verified_draft_url_for_publishingmodel(self):
        # Unpublished page is not visible to anonymous users
        response = self.app.get(
            self.layoutpage.get_absolute_url(),
            user=self.normal_user,
            expect_errors=True)
        self.assertEqual(response.status_code, 404)
        # Unpublished page visible to staff user via '?preview' param redirect
        response = self.app.get(
            self.layoutpage.get_absolute_url(),
            user=self.super_user)
        self.assertEqual(response.status_code, 302)
        self.assertTrue('?preview=' in response['Location'])
        response = response.follow()
        self.assertEqual(response.status_code, 200)
        # Unpublished page is visible to any user with signed '?preview' param
        salt = '123'
        url_hmac = get_draft_hmac(salt, self.layoutpage.get_absolute_url())
        response = self.app.get(
            self.layoutpage.get_absolute_url() + '?preview=%s:%s' % (
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


class TestPublishingOfM2MRelationships(TestCase):
    """ Test publishing works correctly with complex M2M relationships """

    # TODO Add test_contentitem_m2m_backrefs_maintained_on_publish from SFMOMA

    def setUp(self):
        pass

    def test_m2m_handling_in_publishing_clone_relations(self):
        model_a = PublishingM2MModelA.objects.create()
        model_b = PublishingM2MModelB.objects.create()

        #############################################################
        # Start by testing basic M2M functionality without publishing
        #############################################################

        # Start with a clean slate
        self.assertEqual(0, model_a.related_b_models.count())
        self.assertEqual(0, model_b.related_a_models.count())

        # Add/remove M2M draft relationships applies to reverse:
        # PublishingM2MModelA -> PublishingM2MModelB
        model_a.related_b_models.add(model_b)
        self.assertEqual([model_a], list(model_b.related_a_models.all()))
        model_a.related_b_models.remove(model_b)
        self.assertEqual([], list(model_b.related_a_models.all()))

        # Add/remove M2M draft relationships applies to reverse:
        # PublishingM2MModelB -> PublishingM2MModelA
        model_b.related_a_models.add(model_a)
        self.assertEqual([model_b], list(model_a.related_b_models.all()))
        model_b.related_a_models.remove(model_a)
        self.assertEqual([], list(model_a.related_b_models.all()))

        # Add/remove M2M draft relationships works with *through* table
        through_rel = PublishingM2MThroughTable.objects.create(
            a_model=model_a, b_model=model_b)
        self.assertEqual([model_b], list(model_a.through_related_b_models.all()))
        self.assertEqual([model_a], list(model_b.through_related_a_models.all()))
        through_rel.delete()
        self.assertEqual([], list(model_a.through_related_b_models.all()))
        self.assertEqual([], list(model_b.through_related_a_models.all()))

        ############################################
        # Now test M2M functionality with publishing
        ############################################

        # Publish both sides: no relationships yet to published copies
        model_a.publish()
        model_b.publish()
        self.assertEqual(
            [], list(model_a.publishing_linked.related_b_models.all()))
        self.assertEqual(
            [], list(model_b.publishing_linked.related_a_models.all()))
        self.assertEqual(
            [], list(model_a.publishing_linked.through_related_b_models.all()))
        self.assertEqual(
            [], list(model_b.publishing_linked.through_related_a_models.all()))

        # Add M2M relationship: applies to draft copy, not published copies
        model_a.related_b_models.add(model_b)
        model_a.save()
        self.assertEqual([model_b], list(model_a.related_b_models.all()))
        self.assertEqual([model_a], list(model_b.related_a_models.all()))
        self.assertEqual(
            [], list(model_a.publishing_linked.related_b_models.all()))
        self.assertEqual(
            [], list(model_b.publishing_linked.related_a_models.all()))
        # Add through M2M relationship: applies to draft copy, not published copies
        through_rel = PublishingM2MThroughTable.objects.create(
            a_model=model_a, b_model=model_b)
        self.assertEqual([model_b], list(model_a.through_related_b_models.all()))
        self.assertEqual([model_a], list(model_b.through_related_a_models.all()))
        self.assertEqual(
            [], list(model_a.publishing_linked.through_related_b_models.all()))
        self.assertEqual(
            [], list(model_b.publishing_linked.through_related_a_models.all()))

        # Published PublishingM2MModelA is related to draft PublishingModelB
        # when it is published
        model_a.publish()
        self.assertEqual(
            [model_b], list(model_a.publishing_linked.related_b_models.all()))
        # Same applies to the through relationship
        self.assertEqual(
            [model_b], list(model_a.publishing_linked.through_related_b_models.all()))

        # Published PublishingM2MModelB is reverse-related to draft
        # PublishingM2MModelA *after* PublishingM2MModelA's relationship
        # addition is published
        self.assertEqual(
            [model_a], list(model_b.publishing_linked.related_a_models.all()))
        # Same applies to the through relationship
        self.assertEqual(
            [model_a], list(model_b.publishing_linked.through_related_a_models.all()))

        # Published PublishingM2MModelB remains reverse-related to draft
        # PublishingM2MModelA when relationship is removed from drafts but not
        # yet published
        model_a.related_b_models.remove(model_b)
        model_a.save()
        self.assertEqual(
            [model_b], list(model_a.publishing_linked.related_b_models.all()))
        self.assertEqual(
            [model_a], list(model_b.publishing_linked.related_a_models.all()))
        # Same applies to the through relationship
        through_rel.delete()
        self.assertEqual(
            [model_b], list(model_a.publishing_linked.through_related_b_models.all()))
        self.assertEqual(
            [model_a], list(model_b.publishing_linked.through_related_a_models.all()))

        # Remaining reverse relationship manifests as draft-to-published
        # relationships on our draft copies
        self.assertEqual(
            [model_b.publishing_linked], list(model_a.related_b_models.all()))
        self.assertEqual(
            [model_a.publishing_linked], list(model_b.related_a_models.all()))
        # Same applies to the through relationship
        self.assertEqual(
            [model_b.publishing_linked], list(model_a.through_related_b_models.all()))
        self.assertEqual(
            [model_a.publishing_linked], list(model_b.through_related_a_models.all()))

        # Published PublishingM2MModelB is no longer reverse-related to draft
        # PublishingM2MModelA *after* relationship removal is published
        model_a.publish()
        self.assertEqual(
            [], list(model_a.publishing_linked.related_b_models.all()))
        self.assertEqual(
            [], list(model_b.publishing_linked.related_a_models.all()))
        self.assertEqual([], list(model_b.related_a_models.all()))
        self.assertEqual([], list(model_a.related_b_models.all()))
        # Same applies to the through relationship
        self.assertEqual(
            [], list(model_a.publishing_linked.through_related_b_models.all()))
        self.assertEqual(
            [], list(model_b.publishing_linked.through_related_a_models.all()))
        self.assertEqual([], list(model_b.through_related_a_models.all()))
        self.assertEqual([], list(model_a.through_related_b_models.all()))
