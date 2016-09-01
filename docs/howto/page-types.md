# Page types

ICEkit uses [django-fluent-pages] to provide a tree of pages for
your site. Each page is an instance of a Page Type.

Pages can be arranged in any tree shape. The URL of a page is made up of its
slug plus that of its parents.

Pages are meant for 'permanent' parts of your site, ie that represent a
section of your site, and which may appear in permanent site navigation.

Collections of things don't normally work well as pages, because usually it
is not desirable to put each item in the collection in a different place in
the tree, and the tree can get cluttered. For those, consider
using a more traditional Django model, and maybe define a Page Type and/or
Content Plugin for listing/navigating through  the collection.

Examples of content that works well as Pages are Homepage, About Us, Press
Room, Terms & Conditions, Search.

Examples of content that would not work well as Pages (because they are
more conveniently modelled as large collections of similar things) are Blog
Post, Press Release, User, Image, etc.

## Implementation

Although Pages appear in a single tree, each page can be any Page Type. For
example, you can freely mix general-purpose pages with special-purpose pages
like search or redirects. (This is implemented using [django-polymorphic]).

A Page Type always inherits:

  * Fluent's `URLNode`, giving it a title, slug and some other features.

Page Types normally, but don't have to, inherit from:

  * ICEkit's publishing, enabling the page to be published and unpublished.
  * Fluent-contents, enabling the page to have rich modular content.

## Included Page Types

### Layout Page Type

Integrates [FluentContentsPage] and our flexible layouts system.

Add to the `INSTALLED_APPS` setting:

    INSTALLED_APPS += ('icekit.page_types.layout_page', )

### Search Page Type

Integrates [Haystack] search into the hierarchical page tree.

Add to the `INSTALLED_APPS` setting:

    INSTALLED_APPS += ('icekit.page_types.search_page', )

### Abstract Page Type mixins

ICEkit comes with a number of mixins to create different types of content.
Here's a rough guide:

| Rich Content Regions | In the Fluent Page tree | Publishable | Inherit from                                              |
|----------------------|-------------------------|-------------|-----------------------------------------------------------|
| No                   | No                      | No          | `models.Model`                                            |
| No                   | No                      | Yes         | `PublishingModel`                                         |
| No                   | Yes                     | No          | `HtmlPage` or `Page` or `UrlNode`                         |
| No                   | Yes                     | Yes         | `PublishableFluentContentsPage`                           |
| Static               | No                      | No          | `models.Model` (use `PlaceholderField`s)                  |
| Static               | No                      | Yes         | `PublishingModel` (use `PlaceholderField`s)               |
| Static               | Yes                     | No          | `FluentContentsPage`                                      |
| Static               | Yes                     | Yes         | `PublishableFluentContentsPage` (use `PlaceholderField`s) |
| Dynamic              | No                      | No          | `FluentFieldsMixin`                                       |
| Dynamic              | No                      | Yes         | `(FluentFieldsMixin, PublishingModel)`                    |
| Dynamic              | Yes                     | No          | `AbstractUnpublishableLayoutPage`                         |
| Dynamic              | Yes                     | Yes         | `AbstractLayoutPage`                                      |

[django-polymorphic]: https://django-polymorphic.readthedocs.io/
[FluentContentsPage]: http://django-fluent-pages.readthedocs.org/en/latest/api/integration/fluent_contents.html?highlight=fluentcontentspage#the-fluentcontentspage-class
[Haystack]: http://haystacksearch.org/
