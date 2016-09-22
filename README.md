[![Requirements Status](https://img.shields.io/requires/github/ic-labs/glamkit-collections.svg)](https://requires.io/github/ic-labs/glamkit-collections/requirements/)

# Overview

This package contains common code for the SFMOMA website and collection
projects, such as:

  * Abstract collection models.
  * Database routers.
  * Elastic Search integration.

## Abstract and concrete models

You must implement concrete versions of each abstract collection model in an
app named `collection` within your project.

This will allow you to define different methods and behaviour for the models in
each project (as if they were proxy models), but without any foreign key
problems (as with proxy models).

Even if multiple projects access a shared database with different concrete
`collection` implementations, only one set of migrations will be defined in the
`collection_migrations` app, and they can be applied by any project.

Model import paths will be the same, so it should be possible to swap in a
different concrete implementation by factoring it out of the project into a
standalone app and then substituting it for another.

Projects that use a `collection` app MUST include the following setting to
ensure the database is consistent across projects:

    MIGRATION_MODULES = {
        'collection': 'collection_migrations',
    }

These migrations are stored in the top level `collection_migrations` package,
instead of `collection_models.migrations`, because `collection_models` is
installed into projects and that confuses Django.

## Shared Artwork Images

All projects should symlink the `artwork_image_path` to a common directory:

    COLLECTION_MODELS = {
        'artwork_image_path': 'collection-artwork-images',
    }

You can also configure options for artwork thumbnails:

    COLLECTION_MODELS = {
        'artwork_thumbnail_options': {'size': (250, 250)},
    }

## Elastic Search Integration

Install the `collection_models.search` app and use the `index_collection`
management command to populate the search index:

    $ ./manage.py index_collection
