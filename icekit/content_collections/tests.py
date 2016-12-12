from django.contrib.auth import get_user_model
from django.http.request import HttpRequest
from django_webtest import WebTest

from icekit.tests.models import Article, ArticleListing
from icekit.models import Layout

User = get_user_model()


class TestContentCollections(WebTest):
    """
    Test Article publishing
    """

    def setUp(self):
        self.listing_layout = Layout.auto_add(
            'icekit_content_collections/layouts/default.html',
            ArticleListing,
        )

        # Generate an article listing
        # Generate an article attached to the listing

        # Don't publish either
        staff_1 = User.objects.create(
            email='test@test.com',
            is_staff=True,
            is_active=True,
            is_superuser=True,
        )

        self.listing = ArticleListing.objects.create(
            author=staff_1,
            title="Listing Test",
            slug="listing-test",
            layout=self.listing_layout,
        )

        self.article = Article.objects.create(
            parent=self.listing,
            title='Article Test',
            slug="article-test",
        )

        self.listing_2 = ArticleListing.objects.create(
            author=staff_1,
            title="Listing Test 2",
            slug="listing-test-2",
            layout=self.listing_layout,
        )

        self.article_2 = Article.objects.create(
            parent=self.listing_2,
            title='Article Test 2',
            slug="article-test-2",
        )

    def test_model(self):
        req = HttpRequest()
        self.article.publish()
        self.article_2.publish()
        # test the listing contains the published article
        self.assertTrue(self.article.get_published() in self.listing.get_items_to_list(req))
        # ...not the draft one
        self.assertTrue(self.article not in self.listing.get_items_to_list(req))
        # ...not an article that isn't associated with the listing
        self.assertTrue(self.article_2 not in self.listing.get_items_to_list(req))
        self.assertTrue(self.article_2.get_published() not in self.listing.get_items_to_list(req))
        self.article.unpublish()
        self.article_2.unpublish()

    def test_urls(self):
        # Check both have URLs, but 404.
        self.listing_url = self.listing.get_absolute_url()
        self.article_url = self.article.get_absolute_url()

        # check articles are at URLs underneath listing
        self.assertEquals(self.listing_url, '/listing-test/')
        self.assertEquals(self.article_url, '/listing-test/article-test/')

        # published and draft URLs should be the same
        self.listing.publish()

        self.article.publish()
        self.assertEquals(
            self.listing.get_published().get_absolute_url(),
            '/listing-test/'
        )
        self.assertEquals(
            self.article.get_published().get_absolute_url(),
            '/listing-test/article-test/'
        )
        self.listing.unpublish()
        self.article.unpublish()

    def test_article_view(self):
        # test that article shows if it is published
        self.listing.publish()
        self.article.publish()

        self.listing_url = self.listing.get_published().get_absolute_url()
        self.article_url = self.article.get_published().get_absolute_url()

        response = self.app.get(self.article_url)
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, self.listing.title)

        # even if its parent collection listing is not published
        # BOO - looks like fluent-pages won't resolve sub-urls of a page
        # unless the page is published. Leaving commented code to indicate
        # desired, but not necessary, functionality.
        # self.article_2.publish()
        # self.assertFalse(self.listing_2.has_been_published)
        #
        # response = self.app.get(self.article_2.get_absolute_url())
        # self.assertNotContains(response, self.listing_2.title)
        # self.article_2.unpublish()

        self.listing.unpublish()
        self.article.unpublish()

    def test_publishing(self):
        # check URLs 404 by default
        self.listing_url = self.listing.get_absolute_url()
        self.article_url = self.article.get_absolute_url()
        response = self.app.get(self.listing_url, expect_errors=True)
        self.assertEqual(response.status_code, 404)
        response = self.app.get(self.article_url, expect_errors=True)
        self.assertEqual(response.status_code, 404)

        # Publish Article Listing
        self.listing.publish()
        self.listing_url = self.listing.get_published().get_absolute_url()

        # Check it works, but doesn't include the Article
        response = self.app.get(self.listing_url)
        self.assertEqual(response.status_code, 200)

        self.assertNotContains(response, self.article.title)

        # Publish Article
        self.article.publish()
        self.article_url = self.article.get_published().get_absolute_url()
        response = self.app.get(self.article_url)
        self.assertEqual(response.status_code, 200)

        # Check the article listing now includes the Article
        response = self.app.get(
            self.listing_url)
        self.assertContains(response, self.article.title)

        # Unpublish Article Listing
        self.listing.unpublish()
        response = self.app.get(self.listing_url, expect_errors=True)
        self.assertEqual(response.status_code, 404)

        # Unpublish Article to tidy up
        self.article.unpublish()
        response = self.app.get(self.article_url, expect_errors=True)
        self.assertEqual(response.status_code, 404)

    def test_listing(self):
        # Check the listing doesn't include article_2, even if everything is
        # published

        self.article.publish()
        self.article_2.publish()
        self.listing.publish()

        # Refresh article instance
        self.article = Article.objects.get(pk=self.article.pk)

        self.listing_url = self.listing.get_published().get_absolute_url()
        self.article_url = self.article.get_published().get_absolute_url()

        response = self.app.get(self.listing_url)
        self.assertContains(response, self.article.title)
        self.assertNotContains(response, self.article_2.title)

        self.article.unpublish()
        self.article_2.unpublish()
        self.listing.unpublish()
