# ICEkit architectural overview

ICEkit is a next-generation CMS by [the Interaction Consortium],
built on top of [django-fluent-pages] and [django-fluent-contents], in
[Django], running on [Python].

## Rich Content

ICEkit's rich content models allow a human editor to add and arrange many
**Content Items** in any order into one or more **Content Placeholder** slots.
This is accomplished using the [django-fluent-contents] system.

An example of a rich content model could be a Press Release, which could have a
"Main" placeholder and a "More information" placeholder. The "Main" placeholder
could contain 'text', 'images', 'videos', and so on. The "More information"
placeholder may only allow 'press contacts' and 'files' to be added.

Placeholders are specified in the HTML template that is associated with the
rich content model. At render time, each `render_placeholder` template tag
renders all of the content items as they were added by the editor.

A **Content Item** is (usually) a small django model for representing a unit
of content on a page and can have any fields that a normal Django model
has. Each Content Item has at least one associated **Content Plugin** which
specifies how it is to be rendered in a given context and how it is edited in
the admin.

[More on Content Items and Plugins](../howto/plugins.md)

### Database representation

Content Items and the rich content models which contain them are related with
Generic Foreign Keys, which means that there is only one database table for
each Content Item.

### Examples

The `icekit.plugins` package contains reference implementations for many types
of content that you might need in a project.

## Page Types

ICEkit uses [django-fluent-pages] to provide a tree of pages for your site.
Each page is an instance of a Page Type.

Pages can be arranged in any tree shape. The URL of a page is made up of its
slug plus that of its parents.

Pages are meant for 'permanent' parts of your site, ie that represent a section
of your site, and which may appear in permanent site navigation.

Collections of things don't normally work well as pages, because usually it is
not desirable to put each item in the collection in a different place in the
tree, and the tree can get cluttered. For those, consider using a more
traditional Django model, and maybe define a Page Type and/or Content Plugin
for listing/navigating through the collection.

Examples of content that works well as Pages are Homepage, About Us, Press
Room, Terms & Conditions, Search.

Examples of content that would not work well as Pages (because they are more
conveniently modelled as large collections of similar things) are Blog Post,
Press Release, User, Image, etc.

Most pages can be created by the editor using ICEkit's standard Page, which
allows standard Content Items to be added. For more special-purpose pages, such
as Search, you would define a new model that subclasses PageType, and register
it to the page type pool. See [Creating page types].

Page Types usually, but don't have to, implement Rich Content. An example of a
Page Type that doesn't implement rich content is a RedirectPage, which doesn't
render content, but instead redirects to another URL.

### Database representation

Page Types are [django-polymorphic] models.

### Examples

The `icekit.page_types` package contains reference implementations for many
types of page types that you might need in a project.

## Publishing

See the [Publishing] docs for an overview.

## Dashboard

ICEkit comes with an admin dashboard that allows you to prioritise major
content types.

<!-- ## Response Pages -->

[django-fluent-contents]: https://github.com/edoburu/django-fluent-contents
[django-fluent-pages]: https://github.com/edoburu/django-fluent-pages
[django-polymorphic]: https://django-polymorphic.readthedocs.io/
[Django]: https://www.djangoproject.com
[Python]: https://www.python.org
[the Interaction Consortium]: https://interaction.net.au

[Publishing]: ../topics/publishing.md
[Creating page types]: howto/page-types.md
