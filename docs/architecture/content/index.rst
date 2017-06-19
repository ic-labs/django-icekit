Working with rich content
=========================

This section contains an in-depth discussion of the architecture and design
decisions behind GLAMkit's enterprise-level tools for working with content.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   rich-content-models
   content-plugins
   listable
   content-collections
   publishing
   workflow
   page-trees-and-mptt

Debugging tip - finding what view is used
-----------------------------------------

In an ecosystem as rich as GLAMkit's, it can often be confusing to figure
out which view is rendered by which URL. To track this down:

1) Try:

      manage.py show_urls

   which lists all the URL patterns with their corresponding view.

2) If the URL is covered by a non-obvious catch-all, then it's probably a
   ``Page``, as they can be mounted at any URL point. The URL for a ``Page`` is
   normally its slug concatenated with the slugs of its parents, but Pages can
   specify any URL as in ``url_override``. You can see if a Page matches by
   running::

      UrlNode.objects.get_for_path(url)

   and then look at the ``page_type_plugins`` file; for the Page model to see
   what Plugin is used. The ``get_response()`` method of the plugin is the view.

3) As a last resort, enable ``debug_toolbar`` and review the list of templates
   to see what is being rendered, and search the codebase for the template name
   to see where it is used.

   However, note that ``Layout`` objects store the template name in the database.
   If you see a ``layouts`` path in your template name, there is a chance that it's
   specified by a ``Layout`` object. In that case, look in the ``Layout`` object's
   properties (or its admin) to determine which kinds of content can use
   that layout.
