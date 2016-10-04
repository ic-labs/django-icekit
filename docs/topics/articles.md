# `Article`s and `ListingPage`s

`Article`s are publishable content types that live in collections. Normally
articles are mounted under a parent's URL.

An example of an article is a Press Release, which would be mounted under a
Press Release Listing Page. The Listing Page has the URL "/press" and thus all
the Press Releases have the URL "/press/<slug>".

## `ArticleBase`

The `icekit.articles.models.ArticleBase` inherits `title`, `slug` and
publishing fields, and each `ArticleBase` subclass implements some key
functionality:

1. **Links to parents.**
In order for an Article to know its URL (which is based on a parent's URL), it
should define a `parent` link, which is normally a link to a `ListingPage`.

1. **A view.**
If an Article is mounted under a `ListingPage` parent, the ListingPagePlugin
will call `get_response(request, parent)` on the article, which should
return the necessary `HttpResponse`. If the Article is a `fluent_contents`
model, the view functions are implemented by `fluent_contents`.

There is also a class `icekit.articles.models.PolymorphicArticleBase` which
extends the Article class with django-polymorphic functionality, allowing
you to define articles of different shapes and mount them under the same
`parent` model.

## `ListingPage`

The `icekit.articles.models.ListingPage` model is a page type that requires
`get_items_to_list(HttpRequest)` and `get_items_to_route(HttpRequest)` to be
defined in subclasses.

When viewed, ListingPage lists the items returned by `get_items_to_list()`.
`get_items_to_route()` is necessary because an editor may wish to preview
unpublished items (that aren't returned by `get_items_to_list()`)

## Admins

For normal Articles, inherit from `ArticleAdminBase`. For polymorphic articles,
inherit from `PolymorphicArticleParentAdmin` and `PolymorphicArticleChildAdmin`
as shown in the example below.

## Bare-bones example

The following defines a minimal rich content Article, mounted under a
minimal `ArticleCategoryPage`.

In `models.py`:

    from django.db import models
    from icekit.abstract_models import FluentFieldsMixin
    from icekit.articles.abstract_models import ListingPage, ArticleBase


    class ArticleCategoryPage(ListingPage):
        def get_items_to_list(self, request):
            unpublished_pk = self.get_draft().pk
            return Article.objects.published().filter(parent_id=unpublished_pk)

        def get_items_to_route(self, request):
            unpublished_pk = self.get_draft().pk
            return Article.objects.visible().filter(parent_id=unpublished_pk)


    class Article(ArticleBase, FluentFieldsMixin):
        parent = models.ForeignKey(
            ArticleCategoryPage,
            limit_choices_to={'publishing_is_draft': True}
        )

In `admin.py`:

    from django.contrib import admin
    from icekit.admin import FluentLayoutsMixin
    from icekit.articles.admin import ArticleAdminBase
    from .models import Article


    @admin.register(Article)
    class ArticleAdmin(ArticleAdminBase, FluentLayoutsMixin):
        pass

In `page_type_plugins.py`:

    from fluent_pages.extensions import page_type_pool
    from icekit.page_types.layout_page.admin import LayoutPageAdmin
    from icekit.articles.page_type_plugins import ListingPagePlugin
    from .models import ArticleCategoryPage


    @page_type_pool.register
    class ArticleCategoryPagePlugin(ListingPagePlugin):
        model = ArticleCategoryPage


## Bare-bones polymorphic example

The following defines a polymorphic structure of minimal rich content Article,
and a zero-content (except title) `RedirectArticle`.

In `models.py`:

    from django.db import models
    from django.http import HttpResponseRedirect
    from fluent_pages.pagetypes.redirectnode.models import RedirectNode
    from icekit.abstract_models import FluentFieldsMixin
    from icekit.fields import ICEkitURLField
    from icekit.articles.abstract_models import ListingPage, PolymorphicArticleBase
    from django.utils.translation import ugettext_lazy as _


    class ArticleCategoryPage(ListingPage):
        def get_items_to_list(self, request):
            unpublished_pk = self.get_draft().pk
            return Article.objects.published().filter(parent_id=unpublished_pk)

        def get_items_to_route(self, request):
            unpublished_pk = self.get_draft().pk
            return Article.objects.visible().filter(parent_id=unpublished_pk)


    class Article(PolymorphicArticleBase):
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
            response = HttpResponseRedirect(self.new_url)
            response.status_code = self.redirect_type
            return response

        class Meta:
            verbose_name = "Redirect"

In `admin.py`:

    from django.contrib import admin
    from icekit.admin import FluentLayoutsMixin
    from icekit.articles.admin import PolymorphicArticleParentAdmin, \
        PolymorphicArticleChildAdmin
    from .models import Article, LayoutArticle, RedirectArticle


    class ArticleChildAdmin(PolymorphicArticleChildAdmin):
        base_model = Article


    class LayoutArticleAdmin(ArticleChildAdmin, FluentLayoutsMixin):
        base_model=LayoutArticle


    class RedirectArticleAdmin(ArticleChildAdmin):
        base_model=RedirectArticle


    @admin.register(Article)
    class ArticleParentAdmin(PolymorphicArticleParentAdmin):
        base_model = Article
        child_models = ((LayoutArticle, LayoutArticleAdmin),
                        (RedirectArticle, RedirectArticleAdmin),)


Finally, `page_type_plugins.py` is identical to the non-polymorphic example above.
