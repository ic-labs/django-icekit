.. _content-collections:

``AbstractCollectedContent`` and ``AbstractListingPage``
========================================================

A Content Collection is a polymorphic collection of publishable content.
Normally each ``AbstractCollectedContent`` instance is mounted under its
``collection`` URL. The ``AbstractListingPage`` model is designed to act
as such a URLs.

An example of Collected Content is a Press Release, which would be
mounted under a Press Releases Collection Page. The Collection Page
might have the URL ``/press/`` and thus all the Press Releases have the
URL ``/press/<slug>/``.

Use Collected Content when both of the following are true:

-  You have a flat collection of publishable content
-  ... that should have a URL mounted under a Page

Examples:
~~~~~~~~~

-  Articles (at /articles/, or shared amongst /read/, /watch/, /listen/)
-  Press Releases
-  Authors
-  Productions
-  Case studies and research projects
-  Portfolio items (at /portfolio/, or organised by theme)
-  Films (at /films/)
-  People (at /people/, or organised by department)

Counter-examples:
~~~~~~~~~~~~~~~~~

-  Pages in a tree (use fluent-pages)
-  Events (use icekit-events)
-  Assets like images (which don't need to be mounted at a URL)

Possibly useful for:
~~~~~~~~~~~~~~~~~~~~

-  Museum collections, works, objects, creators, exhibitions (the
   CollectionPage needs a great deal of extension)
-  Blog posts (by default, date is not used in the URL)

``AbstractCollectedContent``
----------------------------

Each ``AbstractCollectedContent`` subclass implements some key
functionality:

1. **A ``parent`` attribute.** In order for an instance of Collected
   Content to know its URL (which is based on a collection's URL), it
   should define a ``parent`` attribute, which is normally a
   ``AbstractListingPage`` instance, either hardcoded (if all content
   should live under a single specific parent page) or a foreign key (if
   editors should choose which parent page the content should live
   under).

2. **A view.** When a URL is requested that matches a child URL of
   ``AbstractListingPage``,
   ``ListingPagePlugin.collected_content_view()`` is called, which
   resolves the Collected Content item to show, and calls
   ``get_response(request, parent)`` on that item, where ``parent`` is
   the relevant ``AbstractListingPage``. If the Collected Content item
   is a ``fluent_contents`` model, the default
   ``AbstractCollectedContent.get_response(request, page)`` may be
   sufficient. Otherwise you'll need to implement the method yourself.

``AbstractListingPage``
-----------------------

The ``AbstractListingPage`` model is a page type that requires
``get_items_to_list()`` and ``get_items_to_mount()`` to be defined in
subclasses. When viewed, ListingPage lists the items returned by
``get_items_to_list()``. ``get_items_to_mount()`` is necessary because
an editor may wish to preview urls for items that aren't returned by
``get_items_to_list()``, such as draft items.

Admins
------

Because CollectedContent is polymorphic, you may need to define admins
that inherit from ``CollectedContentParentAdmin`` (for the list view)
and ``CollectedContentChildAdmin`` (for each type of CollectedContent).

These both inherit from ``ContentCollectionAdminBase``, which may
suffice if you only have one type of Collected Content.
