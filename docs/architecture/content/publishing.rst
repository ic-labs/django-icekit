Publishing in ICEkit *
====================

The publishing system used in ICEKit is a re-implementation of concepts
and code from
```django-model-publisher`` <https://github.com/jp74/django-model-publisher>`__,
though heavily customised for our purposes.

It has been customised to work with the fluent style of projects with
polymorphic, translatable models and other such fun.

There are many considerations when using the publishing system with much
history which cannot be covered completely here. This is an attempt to
document the major pieces to allow people to understand how to use the
publishing system and major ideas that need to be known.

Use Publishing in your Project
------------------------------

To use ICEKit Publishing in your project:

-  make sure you install ICEKit with the optional 'publishing' extra to
   get any required libraries, e.g. in your *setup.py* include something
   like: 'django-icekit[forms,search,publishing]'
-  add ``'icekit.publishing'`` to ``INSTALLED_APPS``
-  add ``'icekit.publishing.middleware.PublishingMiddleware'`` to
   ``MIDDLEWARE_CLASSES``

Once set up in this way, the page and plugin models defined in ICEKit
such as ``ArticlePage`` and ``SlideShow`` will gain publishing features
in your project.

Make Custom Publishable Models
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While ICEKit's models will general have publishing features built-in,
you can add publishing to your own models by subclassing both the model
and admin base classes provide in ICEKit.

To make a standard Django model publishable:

-  subclass your model from ``icekit.publishing.models.PublishingModel``
-  subclass your model's admin from
   ``icekit.publishing.admin.PublishingAdmin``

To make a ``FluentContentsPage`` model publishable:

-  subclass your model from
   ``icekit.publishing.models.PublishableFluentContentsPage``
-  subclass your model's admin from ``FluentContentsPageAdmin`` and
   ``icekit.publishing.admin.PublishingAdmin``

To make a fluent contents model (see
`ContentsPlugins <../howto/plugins.md>`__) publishable:

-  subclass your model from
   ``icekit.publishing.models.PublishableFluentContents``
-  subclass your model's admin from
   ``icekit.publishing.admin.PublishableFluentContentsAdmin``

Note: Validating slug uniqueness
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In publishable models, both the draft and published slugs will be
identical, which means declaring your ``SlugField`` with ``unique=True``
will cause Integrity Errors when you try to publish a model instance.

To address this, add
``unique_together = (("slug", "publishing_is_draft"),)`` to your model's
``Meta`` class.

Once you have modified your project's models, make new DB migrations to
apply the additional database fields required for publishing.

Setting up Admin if you are using Fluent Pages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To set up admin for your Fluent Pages:

-  add the setting ``FLUENT_PAGES_PARENT_ADMIN_MIXIN`` with the value
   ``'icekit.publishing.admin.ICEKitFluentPagesParentAdminMixin'`` -
   this is used for the listing page admin, which, in Polymorphic
   models, is separate to the admins for each Page type.
-  ensure your Admin for each page subclasses
   ``FluentContentsPageAdmin`` and
   ``icekit.publishing.admin.PublishingAdmin`` as above.

If your admin needs to render a custom ``change_form_template``, this
template should extend ``admin/fluentpage/change_form.html``, *not*
``admin/publishing/publishing_change_form.html``, which is injected, and
inherits from your template using
``{% extends non_publishing_change_form_template %}``.

Filters
^^^^^^^

Consider providing the publishing-related admin filters provided in
``icekit.publishing.admin`` such as ``PublishingStatusFilter``, and the
publishing status column for listing pages by adding
'publishing\_column' to your admin's ``list_display`` attribute.

Draft Request Context
~~~~~~~~~~~~~~~~~~~~~

The ``icekit.publishing.middleware.PublishingMiddleware`` middleware
class allows privileged users to view draft pages and page content
before it has been published by adding the 'edit' GET parameter to page
URLs, for example: http://site.com/welcome-page/?edit

For the draft request context mechanism to work you must define a text
model setting ``DRAFT_SECRET_KEY`` in the CMS admin at
/admin/model\_settings/setting/ and provide secret value of some kind --
any long password-like text is fine.

If you need to perform custom logic to show content to privileged users
you can use the ``is_draft_request_context()`` global function defined
with the middleware that will return true if, and only if, a privileged
user has explicitly requested to view the draft version of a page by
providing the 'edit' GET parameter.

Implementation details
----------------------

Usage
~~~~~

As complicated as the publishing implementation is behind the scenes --
and it is unfortunately very complicated -- the following usage
guidelines should be enough to use it properly in most situations:

When rendering publishable items, be sure to retrieve only the items
that should be visible to the current user -- draft items for privileged
users, published items for everyone else:

-  use the ``visible()`` queryset method on a QS to publishable items
-  use the ``get_visible()`` object method on an object's FK
   relationship to a publishable item, which may return ``None`` if the
   target item is only a draft
-  use the ``is_visible`` object status flag on a target publishable
   object if you need to process a set of draft and published items in
   code and cannot easily use one of the mechanisms above, or
-  use the ``has_been_published`` object status flag on publishable
   objects when you are processing a set of draft and published copies
   and need to find out whether an object has been published regardless
   of whether the current object happens to be a draft or published
   copy. This is basically equivalent to ``get_visible() is not None``.

Draft Content Protection
^^^^^^^^^^^^^^^^^^^^^^^^

If you forget to explicitly look up the visible version of publishable
items, you will get the draft version instead and could risk displaying
draft content to the public. To avoid this, the publishing
implementation includes a booby trap that should raise a
``PublishingException`` in this situation with a message like *"Illegal
attempt to access 'title' on a DRAFT publishable item..."*. If you see
that, check that you are obtaining the correct visible or published
version of items.

If you are sure you want to access draft attributes within a published
context, you can use ``get_draft_payload()`` on the draft item, or add
the attribute to ``PUBLISHING_PERMITTED_ATTRS`` on the model. ``pk`` is
accessible by default, but most other attributes (particularly reverse
relations) will need to be added to ``PUBLISHING_PERMITTED_ATTRS``
individually.

For some situations you might need to get just the published or draft
copies of items, such as for the search indexes we only ever want
published copies to be indexed regardless of the privileges of the
user/process that triggers the indexing. In these situations, you can
use the corresponding queryset methods and model methods/fields:

-  the ``published()`` queryset method and ``get_published()`` model
   method return the published copy of an item in all cases, regardless
   of the privileges of the current user. This is useful for rendering
   content that should always and only be safe for public consumption.
-  the ``draft()`` queryset method and ``get_draft()`` model method
   return the draft copy of an item in all cases, regardless of the
   privileges of the current user. This is useful for filtering items
   within the Django admin, where only draft items should be accessible.

There are many different states an object can be in. This attempts to
cover at least some of them.

Check if an object is the draft object
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check if an object is the draft object use the ``is_draft`` property
which will return ``True`` if the specific publishable item is a draft
copy, ``False`` otherwise. This will always return the opposite of
``is_published``.

Check if an object is the published object
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check if an object is the published object use the ``is_published``
property which returns ``True`` if the specific publishable item is a
published copy, ``False`` otherwise. This will always return the
opposite of ``is_draft``.

Check if an object has been published
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To check if a publishable item has been published, regardless of whether
the item you are working with happens to be a draft or published copy,
use the ``has_been_published`` property. This returns ``True`` if the
item is itself published, or is a draft that has a published copy.

Relating/retrieving items that are related to draft versions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since only draft versions are shown in the admin, and a published
version isn't constantly available, it usually makes sense to to define
relations to the draft version of an object.

That means that a published version won't have incoming relations, and
accessing reverse relations on the draft version will set off the booby
trap, unless the ``related_name`` is added to
``PUBLISHING_PERMITTED_ATTRS``.

A pattern like this is normally safest (``pk`` is a permitted
attribute):

::

    RelatedModel.objects.filter(fk_id=self.get_draft().pk)

Data model
~~~~~~~~~~

The general gist is that every item in Django's CMS admin is created a
**draft** copy, which may or may not have an associated **published**
copy. When a draft copy is published it is duplicated, along with some
processing of related content, such that the DB will contain two copies
of the same item: one draft, one published. The Django admin remains
largely oblivious to the existence of published copies. When displaying
content to users, the draft or published version of publishable items is
rendered depending on the privileges of the user: admins might see draft
content rendered, whereas the public must only ever see rendered
versions of the corresponding published copy (if there is one).

NOTE: The data model for ICEKit's current publishing approach is a
tweaked version of the one from ``django-model-publisher`` and SFMOMA.

Each publishable model is assigned four main extra columns:

-  ``publishing_linked``: a 1-to-1 relationship to self, or as near as
   possible to self, that on the draft copy of a publishable item will
   point to its **published** copy, if any.
-  ``publishing_is_draft``: boolean field, ``True`` if the current item
   is a draft copy (the default) or ``False`` if it is the published
   copy.
-  ``publishing_modified_at``: timestamp used mainly to track when
   publishable items are updated so that you can work out whether the
   published copy is up-to-date compared to the draft copy version. That
   is, any up-to-date published copy should have a
   ``publishing_modified_at``: timestamp value equal to or later than
   the corresponding draft item.
-  ``publishing_published_at``: used to set a future time when the item
   is to be considered published, for scheduling publication. I don't
   think we use or implement this at all...

Handling unique fields
~~~~~~~~~~~~~~~~~~~~~~

Because the publishing approach creates draft and published copies of
models, any fields marked as ``unique=True`` will raise IntegrityErrors
unless the field is made non-unique.

Related fields (``ForeignKey``, ``ManyToMany``, etc)
----------------------------------------------------

When referring to publishable ``ForeignKey`` or ``ManyToMany`` data
items -- such as pages -- on an object that is being rendered or
displayed to the public, it is important to specify that you only want
the **published** versions to be displayed.

During administration and saving of objects always reference the
**draft** version, but when accessing ``ForeignKey`` or ``ManyToMany``
relationships in public contexts such as templates use the ``visible``
method on publishable query sets (i.e. ``UrlNodeQuerySet.published``) to
get the correct draft or published object versions for the current user.

For example, here is a template directive that will do the right thing
when rendering related content for the public and for site admins:

::

    {% with published_pages=instance.pages.visible %}
    {% endwith %}

There has been an issue discovered where ``ManyToMany`` fields referring
both ways on models have the many to many data cloned for published and
unpublished objects. This is currently being worked on.
