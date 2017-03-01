Important concepts
==================

.. TODO: cross-ref from glossary

In a nutshell, ICEkit allows easy creation of Rich content models. Rich
content models contain one or more placeholders. Placeholders represent
areas in a template that contain zero or more rich content items.

.. TODO: screenshot of placeholder editing.

.. _rich-content-models:

Rich content models
-------------------

ICEkit's rich content models allow a human editor to add and arrange
many **Content Items** in any order into one or more **Content
Placeholder** slots. This is accomplished using the
`django-fluent-contents <https://github.com/edoburu/django-fluent-contents>`__
system.

An example of a rich content model could be a Press Release, which could
have a "Main" placeholder and a "More information" placeholder. The
"Main" placeholder could contain 'text', 'images', 'videos', and so on.
The "More information" placeholder may only allow 'press contacts' and
'files' to be added.

.. TODO: screenshot

Placeholders are specified in the HTML template that is associated with
the rich content model. At render time, each ``{% render_placeholder %}``
template tag renders all of the content items as they were added by the
editor.

.. _rich-content-plugins:

Rich content items
------------------

A **Content item** is (usually) a small Django model for representing a
unit of content on a page and can have any fields that a normal Django
model has. Each
Content Item has at least one associated **Content Plugin** which specifies
how it is to be rendered in a given context and how it is edited in the admin.

The ``icekit.plugins`` package contains reference implementations for many
types of content that you might need in a project.


.. admonition:: Database structure

   Content plugins and the rich content models which contain them are related
   with Django Generic Foreign Keys, which means that there is only one database
   table for each content plugin. This is unlike CMSes like FeinCMS, which
   create separate tables for every pair of content plugin and content model.


Pages vs Collections
--------------------

ICEkit uses
`django-fluent-pages <https://github.com/edoburu/django-fluent-pages>`__
to provide a **tree of pages** for your site. Pages can be arranged in any tree
shape. The slug of a page is made up of its slug plus that of its parent.

Pages are meant for 'permanent' parts of your site, ie that represent a
section of your site, and which may appear in permanent site navigation.

Examples of content that works well as Pages are Homepage, About Us,
Press Room, Terms & Conditions, Search.

.. note:

   Page Types usually, but don't have to, implement rich content placeholders.
   An example of a Page Type that doesn't implement rich content is a
   RedirectPage, which doesn't render content, but instead redirects to
   another URL.

On the other hand, **collections of content** don't normally work well in the
page tree, because usually collections need browsing and sorting differently
from how they would appear in a tree structure, and besides, a single tree
would get cluttered with thousands of individual collection items.

Examples of content that would not work well as Pages (because they are
more conveniently modelled as large collections of similar things) are
Blog Post, Press Release, User, Artwork, etc.

For collections of content, consider using a more traditional Django model,
and maybe define a Page Type and/or Content Plugin for listing/navigating
through the collection. ICEkit provides some
:ref:`collection helpers <content-collections>` to aid this process.

.. TODO: link to creating content models/content plugins

.. admonition::Database representation

   Page Types are
   `django-polymorphic <https://django-polymorphic.readthedocs.io/>`_
   models.

The ``icekit.page_types`` package contains reference implementations for
many types of page types that you might need in a project.

Publishing
----------
.. TODO: proper description here?

See the :ref:`Publishing <publishing>` docs for an overview.

