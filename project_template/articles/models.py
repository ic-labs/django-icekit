from django.db import models
from django.http import HttpResponseRedirect
from fluent_pages.pagetypes.redirectnode.models import RedirectNode
from icekit.abstract_models import FluentFieldsMixin
from icekit.fields import ICEkitURLField

from icekit.articles.abstract_models import ListingPage, PolymorphicArticleBase
from django.utils.translation import ugettext_lazy as _


class ArticleCategoryPage(ListingPage):

    class Meta:
        verbose_name = "Article category"

    def get_items(self):
        """
        :return: articles attached to the draft version of this page that
        will be listed
        """
        unpublished_pk = self.get_draft().pk
        return Article.objects.published().filter(parent_id=unpublished_pk)

    def get_visible_items(self):
        """
        :return: articles attached to the draft version of this page that can
        be previewed.
        """
        unpublished_pk = self.get_draft().pk
        return Article.objects.visible().filter(parent_id=unpublished_pk)


class Article(PolymorphicArticleBase):
    """
    Default GLAMkit articles have a parent ArticleCategoryPage
    """
    parent = models.ForeignKey(
        ArticleCategoryPage,
        limit_choices_to={'publishing_is_draft': True}
    )

class LayoutArticle(Article, FluentFieldsMixin):
    class Meta:
        verbose_name = "Article"


class RedirectArticle(Article):
    new_url = ICEkitURLField(
        help_text=_('The URL to redirect to.')
    )
    redirect_type = models.IntegerField(
        _("Redirect type"),
        choices=RedirectNode.REDIRECT_TYPE_CHOICES,
        default=302,
        help_text=_(
            "Use 'normal redirect' unless you want to transfer SEO ranking to the new page."
        )
    )

    def get_response(self, request, *args, **kwargs):
        """
        Return the redirect response.

        :param request: Django request object.
        :param args: Extra positional arguments.
        :param kwargs: Extra keyword arguments.
        :return: Redirect response.
        """
        response = HttpResponseRedirect(self.new_url)
        response.status_code = self.redirect_type
        return response

    class Meta:
        verbose_name = "Redirect"
