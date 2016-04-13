# -*- coding: utf-8 -*-
from datetime import timedelta
import urlparse

from django.contrib.auth import get_user_model
from django.contrib.auth.models import AnonymousUser, Group
from django.contrib.sites.models import Site
from django.core.urlresolvers import reverse
from django.http import HttpResponseNotFound, QueryDict
from django.test import TestCase, RequestFactory
from django.test.utils import override_settings
from django.utils import timezone

from mock import patch, Mock

from django_dynamic_fixture import G

from fluent_pages.models import PageLayout
from fluent_pages.pagetypes.fluentpage.models import FluentPage

from icekit.plugins.slideshow.models import SlideShow

from icekit.publishing.managers import DraftItemBoobyTrap
from icekit.publishing.middleware import PublishingMiddleware, \
    get_middleware_active_status, get_current_user, get_draft_status, \
    override_current_user
from icekit.publishing.utils import get_draft_hmac, verify_draft_url, \
    get_draft_url
from icekit.publishing.tests_base import BaseAdminTest

User = get_user_model()


class TestPublishingModelAndQueryset(TestCase):
    """
    Test base publishing features, and that publishing works as expected for
    simple models (as opposed to Fluent content or page models)
    """

    def setUp(self):
        self.site = G(Site)
        self.user_1 = G(User)
        self.page_layout_1 = G(PageLayout)
        self.page_1 = FluentPage.objects.create(
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
            draft_instance.publishing_modified_at
            < draft_instance.publishing_linked.publishing_modified_at)
        # Draft instance is no longer dirty after publishing
        self.assertFalse(draft_instance.is_dirty)

        # Modify the draft item, so published item is no longer up-to-date
        draft_instance.title = draft_instance.title + ' changed'
        draft_instance.save()
        # Draft instance is now dirty after modification
        self.assertTrue(
            draft_instance.publishing_modified_at
            > draft_instance.publishing_linked.publishing_modified_at)
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
        with patch('icekit.publishing.models.get_draft_status') as p:
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
        with patch('icekit.publishing.models.get_draft_status') as p:
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

    def test_publishing_queryset_draft(self):
        self.assertEqual(
            [self.slide_show_1], list(SlideShow.objects.draft()))
        # Only draft items returned even when published
        self.slide_show_1.publish()
        self.assertEqual(
            [self.slide_show_1], list(SlideShow.objects.draft()))
        # Confirm we only get draft items regardless of `get_draft_status`
        with override_settings(DEBUG=True):
            with patch('icekit.publishing.managers.get_draft_status') as p:
                p.return_value = False
                self.assertEqual(
                    [self.slide_show_1], list(SlideShow.objects.draft()))

    def test_queryset_published(self):
        self.assertEqual(
            [], list(SlideShow.objects.published()))
        self.slide_show_1.publish()
        # Exchange draft items for published by default
        self.assertEqual(
            [self.slide_show_1.publishing_linked],  # Compare published copy
            list(SlideShow.objects.published()))
        # Confirm we only get published items regardless of `get_draft_status`
        with patch('icekit.publishing.managers.get_draft_status') \
                as mock_get_draft_status:
            mock_get_draft_status.return_value = True
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
        # Without exchange of drafts for published
        self.assertEqual(
            set([self.slide_show_1.publishing_linked, self.slide_show_1]),
            set(SlideShow.objects.published(with_exchange=False)))

    def test_queryset_visible(self):
        self.slide_show_1.publish()
        # In draft mode, `visible` delegates to `draft`
        draft_set = set(SlideShow.objects.draft())
        with patch('icekit.publishing.managers.get_draft_status') as p:
            p.return_value = True
            self.assertEqual(draft_set, set(SlideShow.objects.visible()))
        # In non-draft mode, `visible` delegates to `published`
        published_set = set(SlideShow.objects.published())
        with patch('icekit.publishing.managers.get_draft_status') as p:
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

    def test_queryset_iterator(self):
        self.slide_show_1.publish()
        # Confirm drafts are wrapped with booby trap on iteration over
        # publishable QS in debug mode in a public request context.
        with override_settings(DEBUG=True):
            with patch('icekit.publishing.managers'
                       '.get_middleware_active_status') as p:
                p.return_value = True
                self.assertTrue(all(
                    [i.__class__ == DraftItemBoobyTrap
                     for i in SlideShow.objects.all() if i.is_draft]))
                # Published items are never wrapped
                self.assertTrue(all(
                    [i.__class__ != DraftItemBoobyTrap
                     for i in SlideShow.objects.all() if i.is_published]))
        # Confirm drafts returned as normal on iteration when not in debug mode
        with override_settings(DEBUG=False):
            with patch('icekit.publishing.managers'
                       '.get_middleware_active_status') as p:
                p.return_value = True
                self.assertTrue(all(
                    [i.__class__ != DraftItemBoobyTrap
                     for i in SlideShow.objects.all() if i.is_published]))

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
        self.assertTrue(mw.get_middleware_active_status())
        self.assertTrue(get_middleware_active_status())

        # Response processing clears middleware active flag
        mw.process_response(self._request(), self.response)
        self.assertFalse(mw.get_middleware_active_status())
        self.assertFalse(get_middleware_active_status())

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

    def test_middleware_edit_param_triggers_draft_status(self):
        mw = PublishingMiddleware()

        # Request processing normal URL does not trigger draft status
        mw.process_request(self._request())
        self.assertFalse(mw.get_draft_status())
        self.assertFalse(get_draft_status())

        # Request URL from Content Reviewers is always draft, no 'edit' req'd
        request = self._request(user=self.reviewer_user)
        mw.process_request(request)
        self.assertTrue(mw.get_draft_status())
        self.assertTrue(get_draft_status())

        # Request URL with 'edit' param triggers draft for staff
        request = self._request(data={'edit': ''}, user=self.staff_1)
        mw.process_request(request)
        self.assertTrue(mw.get_draft_status())
        self.assertTrue(get_draft_status())

        # Non-privileged users cannot trigger draft mode with 'edit' param
        request = self._request(data={'edit': ''}, user=self.public_user)
        mw.process_request(self._request())
        self.assertFalse(mw.get_draft_status())
        self.assertFalse(get_draft_status())

        # Response processing clears draft status
        mw.process_response(self._request(), self.response)
        self.assertFalse(mw.get_draft_status())
        self.assertFalse(get_draft_status())

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
        self.site = G(Site)
        self.user_1 = G(User)
        self.page_layout_1 = G(PageLayout)
        self.page_1 = FluentPage.objects.create(
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


# TODO Enable these test cases based on SFMOMA once Fluent publishing is done
class TestFluentPublishing(TestCase):
    """ Test publishing features and behaviour for Fluent-based items """

    def setUp(self):
        self.skipTest("Publishing not yet implemented for Fluent items")

    def test_queryset_published(self):
        # Setting publication start & end dates on draft has no effect
        self.slide_show_1.publication_date = \
            timezone.now() + timedelta(seconds=1)
        self.slide_show_1.publication_end_date = \
            timezone.now() - timedelta(seconds=1)
        self.slide_show_1.save()
        self.assertEqual(
            set([self.slide_show_1.publishing_linked, self.slide_show_1]),
            set(SlideShow.objects.published(with_exchange=False)))
        # Test publication date filtering: start date
        self.slide_show_1.publishing_linked.publication_date = \
            timezone.now() + timedelta(seconds=1)
        self.slide_show_1.publishing_linked.save()
        self.assertEqual(
            set(), set(SlideShow.objects.published(with_exchange=False)))
        # Test publication date filtering: end date
        self.slide_show_1.publishing_linked.publication_date = None
        self.slide_show_1.publishing_linked.publication_end_date = \
            timezone.now() - timedelta(seconds=1)
        self.slide_show_1.publishing_linked.save()
        self.assertEqual(
            set(), set(SlideShow.objects.published(with_exchange=False)))
        # Test publication date filtering: clear start & end dates
        self.slide_show_1.publishing_linked.publication_end_date = None
        self.slide_show_1.publishing_linked.save()
        self.assertEqual(
            set([self.slide_show_1.publishing_linked, self.slide_show_1]),
            set(SlideShow.objects.published(with_exchange=False)))

    # TODO Add test_m2m_handling_in_publishing_clone_relations from SFMOMA

    # TODO Add test_contentitem_m2m_backrefs_maintained_on_publish from SFMOMA
