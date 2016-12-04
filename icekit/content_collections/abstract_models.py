from icekit.mixins import ListableMixin

try:
	from urlparse import urljoin
except ImportError:
	from urllib.parse import urljoin

from django.core.exceptions import ValidationError
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

    def get_title(self):
        return self.title

    def validate_unique_slug(self):
        """
        Ensure slug is unique for this model. This check is aware of publishing
        but is otherwise fairly basic and will need to be customised for
        situations where models with slugs are not in a flat hierarchy etc.
        """
        clashes_qs = type(self).objects.filter(slug=self.slug)
        if self.pk:
            clashes_qs = clashes_qs.exclude(pk=self.pk)
        if isinstance(self, PublishingModel):
            clashes_qs = clashes_qs.filter(
                publishing_is_draft=self.publishing_is_draft)
        if clashes_qs:
            raise ValidationError(
                "Slug '%s' clashes with other items: %s"
                % (self.slug, clashes_qs))

    def clean(self):
        super(TitleSlugMixin, self).clean()
        self.validate_unique_slug()

    def publishing_prepare_published_copy(self, draft_obj):
        """ Perform slug validation on publish, not just when saving draft """
        self.validate_unique_slug()

    def __unicode__(self):
        return self.title

class PluralTitleSlugMixin(TitleSlugMixin):
    title_plural = models.CharField(max_length=255, blank=True, help_text="Optional plural version of title (if appending 's' isn't correct)")

    class Meta:
        abstract = True

    def get_plural(self):
        if self.title_plural:
            return self.title_plural
        return u"{0}s".format(self.title)

    def get_title(self):
        return self.get_plural()


class AbstractListingPage(AbstractLayoutPage):
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
            "Please implement `get_items_to_list(request)` on %r" % type(self)
        )

    def get_items_to_mount(self, request):
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
            "Please implement `get_items_to_mount(request)` on %r" % type(self)
        )

class AbstractCollectedContent(ListableMixin):
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

    def suppressed_message(self):
        parent = self.parent
        if not parent.has_been_published:
            return "The '%s' page that this '%s' belongs to needs to be " \
                   "published before it can be viewed by the public" % (type(parent)._meta.verbose_name, type(self)._meta.verbose_name, )
        return None

    def get_absolute_url(self):
        """
        The majority of the time, the URL is the parent's URL plus the slug.
        If not, override this function.
        """

        # Appending "/" to avoid a) django redirect and b) incorrect edit slug
        # for the admin.
        return urljoin(self.parent.get_absolute_url(), self.slug + "/")

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
