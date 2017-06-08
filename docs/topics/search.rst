Search
======

GLAMkit uses Haystack with an Elastic Search backend for its onsite
search.

It comes with a simple SearchIndex,
``icekit.utils.search.AbstractLayoutIndex`` which works well on content
that:

-  Implements the ``ListableMixin`` for getting list content
-  Uses fluent contents (having a number of rich content placeholders)
-  Is publishable (the index queryset defaults to
   ``objects.published()``)
-  Is polymorphic (the ``django_ct`` value always matches
   ``get_model()``, rather than varying by the object being indexed.

GLAMkit's default content models use this index:

-  Page (including LayoutPage, ArticleListingPage, etc.)
-  Article
-  Author

And in optional libraries: \* icekit\_events.EventBase \*
icekit\_press\_releases.PressRelease \* glamkit\_collections.WorkBase \*
glamkit\_collections.CreatorBase \* etc.

``AbstractLayoutIndex`` renders the
``search/indexes/icekit/default.txt`` template which indexes
ListableMixin content, all Fluent placeholders, and some common content
fields. You can render a different template in your search index by
redeclaring the ``title`` field. HTML tags are stripped and HTML
entities are converted to unicode.

Rebuilding the search index
---------------------------

The management command (provided by Haystack) ``manage.py rebuild_index`` will
repopulate the ElasticSearch index with all documents.

Similarly, ``manage.py update_index`` will repopulate the ElasticSearch index
with only documents that need to be re-indexed.

Automatically updating the search index
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The task ``icekit.tasks.UpdateSearchIndexTask`` updates the search index, and is
configured to run every 15 minutes in ``settings.CELERYBEAT_SCHEDULE``.

For more information, see :doc:`/topics/celery`

Using ``AbstractLayoutIndex``
-----------------------------

As minimal example, create ``search_indexes.py`` on a publishable,
``ListableMixin`` model:

::

    from haystack import indexes
    from icekit.utils.search import AbstractLayoutIndex
    from . import models

    class MyModelIndex(AbstractLayoutIndex, indexes.Indexable):
        def get_model(self):
            return models.MyModel

Publish the content you want to be indexed, then run
``manage.py update_index``.

Search Page
-----------

The ``icekit.page_types.search_page`` page plugin implements a search
page. To use it for your site, create a search page, and preview/publish
it.
