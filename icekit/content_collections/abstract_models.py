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


class AbstractListingPage(AbstractLayoutPage):
    """
    A Page type that serves lists of things. Good for
    e.g. PressReleaseListingPage or ArticleCategoryPage.
    """
    class Meta:
        abstract = True

    def get_public_items(self):
        """
        Get the items that are listed on this page.
        Remember that incoming relations will be on the draft version of
        the page. Do something like this:

            unpublished_pk = self.get_draft().pk
            return Article.objects.published().filter(parent_id=unpublished_pk)

        Editors normally expect to only see published() items in a listing, not
        visible() items, unless clearly marked as such.

        :return: the items that are associated with this page
        """
        raise NotImplementedError(
            "Please implement `get_public_items()` on your ListingPage model"
        )


    def get_visible_items(self):
        """
        Get all items that are associated with this page and can be previewed
        by the user.
        Again, incoming relations will be on the draft version of
        the page. Do something like this:

            unpublished_pk = self.get_draft().pk
            return Article.objects.visible().filter(parent_id=unpublished_pk)

        Editors normally expect to only see published() items in a listing, not
        visible() items, unless clearly marked as such.

        :return: the items that are associated with this page
        """
        raise NotImplementedError(
            "Please implement `get_visible_items()` on your ListingPage model"
        )

class AbstractCollectedContent(models.Model):
    """
    Content collections can be mounted into a publishable listing page,
    which has the URL returned by `get_parent_url()`.

    Subclasses should define a `parent` attribute, or override either
    `get_parent_url()` or `get_absolute_url()`.

    Subclasses should also define get_response for rendering itself, or
    get_layout_template_name() in order to render Rich Content.
    """

    class Meta:
        abstract = True
#         unique_together = (('slug', 'publishing_is_draft', 'parent'),)
#
#     def get_parent_url(self):
#         if not hasattr(self, 'parent'):
#             raise NotImplementedError("ContentCollectionBase subclasses need to implement `parent` or override `get_parent_url` or `get_absolute_url`.")
#
#         parent = self.parent.get_published() or self.parent.get_draft()
#         return parent.get_absolute_url()
#
#     def get_absolute_url(self):
#         parent_url = self.get_parent_url()
#         return urljoin(parent_url, self.slug) + "/"
#
    def suppressed_message(self):
        parent = self.parent
        if not parent.has_been_published:
            return "The '%s' page that this '%s' belongs to needs to be " \
                   "published before it can be viewed by the public" % (type(parent)._meta.verbose_name, type(self)._meta.verbose_name, )
        return None
#
    def get_response(self, request, parent, *args, **kwargs):
        """
        Render this collected content to a response.

        :param request: the request
        :param parent: the parent collection
        :param args:
        :param kwargs:
        :return:
        """
        context = {
            'page': self,
        }
        try:
            return TemplateResponse(
                request,
                self.get_layout_template_name(),
                context
            )
        except AttributeError:
            raise AttributeError("You need to define "
                 "`get_layout_template_name()` on your `%s` model, "
                 "or override `get_response()`" % type(self).__name__)
