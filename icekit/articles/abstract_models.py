from urlparse import urljoin

from django.template.response import TemplateResponse

from icekit.publishing.models import PublishingModel
from polymorphic.models import PolymorphicModel

from icekit.page_types.layout_page.abstract_models import AbstractLayoutPage
from django.db import models

class TitleSlugMixin(models.Model):
    # TODO: this should perhaps become part of a wider ICEkit mixin that covers
    # standard content behaviour.

    title = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255)

    class Meta:
        abstract = True

    def __unicode__(self):
        return self.title


class ListingPage(AbstractLayoutPage):
    """
    A Page type that serves lists of things. Good for
    e.g. PressReleaseListingPage or ArticleCategoryPage.
    """
    class Meta:
        abstract = True

    def get_items_to_list(self, request):
        """
        Get the items that will be show in this page's listing.

        Remember that incoming relations will be on the draft version of
        the page. Do something like this:

            unpublished_pk = self.get_draft().pk
            return Article.objects.published().filter(parent_id=unpublished_pk)

        Editors normally expect to only see published() items in a listing, not
        visible() items, unless clearly marked as such.

        :return: the items to be rendered in the listing page
        """
        raise NotImplementedError(
            "Please implement `get_items_to_list(request)` on %e" % type(self)
        )

    def get_items_to_route(self, request):
        """
        Get all items that are associated with this page and can be previewed
        by the user at a URL.
        Again, incoming relations will be on the draft version of
        the page. Do something like this:

            unpublished_pk = self.get_draft().pk
            return Article.objects.visible().filter(parent_id=unpublished_pk)

        :return: the items with URL path endpoints under this page's path
        """
        raise NotImplementedError(
            "Please implement `get_items_to_route(request)` on %r" % type(self)
        )


class ArticleBase(PublishingModel, TitleSlugMixin):
    """
    Articles can be mounted into a publishable listing page,
    which has the URL returned by `get_parent_url()`.

    Subclasses should define a `parent` attribute, or override either
    `get_parent_url()` or `get_absolute_url()`.

    Subclasses should also define get_response for rendering itself, or
    get_layout_template_name() in order to render Rich Content.
    """

    class Meta:
        abstract = True
        unique_together = (('slug', 'publishing_is_draft', 'parent'),)

    def get_parent_url(self):
        if not hasattr(self, 'parent'):
            raise NotImplementedError("PublishableArticle subclasses need to implement `parent` or `get_parent_url`.")

        parent = self.parent.get_published() or self.parent.get_draft()
        return parent.get_absolute_url()

    def get_absolute_url(self):
        parent_url = self.get_parent_url()
        return urljoin(parent_url, self.slug) + "/"

    def is_suppressed_message(self):
        if not self.parent.has_been_published:
            return "This article's parent needs to be published before it " \
                "can be viewed by the public"
        return None

    def get_response(self, request, parent, *args, **kwargs):
        context = {
            'page': self,
            'title': self.title
        }
        try:
            return TemplateResponse(
                request,
                self.get_layout_template_name(),
                context
            )
        except AttributeError:
            raise AttributeError("You need to define "
                 "`get_layout_template_name()` on your `ArticleBase` model, "
                 "or override `get_response()`")


class PolymorphicArticleBase(PolymorphicModel, ArticleBase):
    class Meta:
        abstract = True
