Changelog
=========

In development
--------------

-  Add ``icekit.workflow`` application to associate, manage, and filter
   workflow state information like status and user-assigment for
   arbitrary models.

-  Add ``ICEkitContentsMixin`` and ``ICEkitFluentContentsMixin``
   abstract classes in ``icekit.models`` to use as a base for models
   that will include publishing and workflow features.

-  Add ``ICEkitContentsAdmin`` and ``ICEkitFluentContentsAdmin`` admin
   classes in ``icekit.admin`` as bases for admins for models with
   publishing and workflow features.

-  Add workflow features to all publishable models in ICEkit using the
   new abstract model mixins and admin base classes mentioned above.

-  Preview pages are now visually highlighted, and have a different HTML
   title.

-  "Preview draft" button is now near "View published" button.

-  "Slideshow" is now renamed "Image Gallery" and there is a new Image
   Gallery content plugin available (which renders a grid of thumbnails
   into a lightbox).

-  ``icekit.content_collections`` app which defines an abstract listing
   page type that lists a collection of content, and an abstract model
   for collected content that appears in such a collection. This is a
   common pattern.

-  New ``icekit.page_types.author`` app which models a content author
   and a listing page, based on the ``content_collections`` pattern.

-  New ``icekit.page_types.article`` app which is a concrete
   implementation of the content collections pattern.

-  Ignore ``.env`` and ``docker-cloud.*.yml`` files, which frequently
   contain secrets that should not be committed.

-  New ``ContactPerson`` model + and plugin added, allowing adding of
   staff contacts to most types of content.

-  Verbose Name for "o embed with caption" is now "Embedded media"

-  Text plugin now has a style setting

-  Overhaul of search system, using a consistent approach to index and
   depict rich/publishable/polymorphic models, and to facet on them.

-  Documentation is refactored into ReStructuredText. This means much
   more coherence, and the ability to generate documentation from within
   code. Also documentation focuses on GLAMkit rather than ICEkit to align
   with current development focus.

Breaking changes
~~~~~~~~~~~~~~~~

-  ``AbstractLayoutPage`` now includes ListableMixin and HeroMixin. All
   models which inherit from this will need a new migration.

-  The initial migration for ``icekit.plugins.slideshow`` had the wrong
   database table name, which meant that the ``0004_auto_20160821_2140``
   migration would not have correctly renamed the database table when
   upgrading to ``>=0.10`` from an earlier version.

   To fix this, run the following SQL manually:

   ::

       ALTER TABLE "slideshow_slideshow" RENAME TO "icekit_plugins_slideshow_slideshow";

   If you have yet to upgrade from ``<0.10``, you don't need to do
   anything.

-  ``icekit.articles`` is no more. Functionality is moved to
   ``icekit.content_collections``.

-  The ``FEATURED_APPS`` setting has moved to
   ``ICEKIT['DASHBOARD_FEATURED_APPS']``, and is now a list, not a
   tuple, so as to support item assignment.

-  Added HeroMixin and ListableMixin to LayoutPage and Article. This
   will break ported/subclass models that define similarly-named fields.
   Either remove the definition or migrate data somehow.

-  The required version of Press Releases removes the ``PressContact``
   model, in favour of ``ContactPerson``. If you have ``PressContacts``,
   you will need to migrate to the new model.

0.15 (2016-09-27)
-----------------

-  Improvements to publishing to make it accomodate more types of
   content.

-  Fix bug where the content items and placeholders associated with a
   fluent content model (other than a page) were not included in the
   published copy.

-  Provide ``icekit.publishing.models.PublishableFluentContents`` and
   ``icekit.publishing.admin.PublishableFluentContentsAdmin`` as base
   classes for fluent content models and admins, to help keep things
   DRY.

-  Minor docs on testing.

-  Greater test coverage.

Breaking changes
~~~~~~~~~~~~~~~~

-  Import model mixins ``FluentFieldsMixin``, ``LayoutFieldMixin``, and
   ``ReadabilityMixin`` from ``icekit.mixins`` module instead of
   ``icekit.abstract_models``.

-  Import admin mixin ``FluentLayoutsMixin`` from
   ``icekit.admin_mixins`` module instead of ``icekit.admin``.

0.14.1 (2016-09-26)
-------------------

-  ICEkit gets a facelift. Content editing now looks cleaner and easier
   to scan. Reordering items is animated, meaning it's easier to keep
   track of what got moved.

-  Improved Image controls, optionally including a title in the caption.

-  ``alt_text`` is no longer required - some images don't provide
   content that is useful to users who can't see them, though the
   ``alt=`` attribute is still always included in HTML.

-  Fix a bug where looking for ``help_text`` in a placeholder slot that
   had no manual configuration raised a 500, resulting in no layout data
   found.

-  Fix fatal error (typo) in ``startproject.sh`` script.

-  Update ``.editorconfig``, and add to project template.

-  Tag Docker images during build on Travis CI for release versions.

0.14 (2016-09-20)
-----------------

-  Update the recommended method of running projects via ``Docker`` and
   ``go.sh`` to provide a more consistent and familiar experience for
   developers.

   Old:

   ::

       $ docker-compose up                         # Run all services and log to stdout (no interactivity)
       $ docker-compose exec django entrypoint.sh  # Shell into running `django` container to run interactive processes

   New:

   ::

       $ docker-compose run --rm --service-ports django  # Start dependant services and shell into a new `django` container

   The benefits are that:

   1. We start with an interactive terminal in which we can any number
      of interactive processes in a familiar way.

   2. It's much easier and quicker to stop and restart the main process
      (e.g. the Django dev server) without having to stop and restart
      dependant services.

   3. We aren't overwhelmed by several screens of log output from all
      the service dependencies.

   4. We don't start a WSGI process in a non-interactive ``django``
      service, then have to shell into the container to stop it and
      replace it with an interactive one.

-  Use different locations for ``PYTHONUSERBASE`` (via Docker) and
   virtualenv (via ``go.sh``) directories, to avoid conflicts.

-  Isolate the ``go.sh`` BASH shell from user's personal ``.bashrc`` and
   ``.profile`` files to avoid conflicts and unexpected behaviour.

-  Validate that manually installed dependencies are available when run
   via ``go.sh``, and fail loudly.

-  Call ``setup-django.sh`` by default when ``go.sh`` is called without
   arguments, to mimic ``docker-compose run ... django`` default
   behaviour.

-  Improve the ``runtests.sh`` script:

   1. Use a database name derived from project directory and Git branch.

   2. Restore ``test_initial_data.sql`` instead of ``initial_data.sql``
      before running tests, so ``initial_data.sql`` can be used for
      development.

   3. Only run and report on project tests when run in a project
      context.

-  Improve detection of ``*.sql`` file vs source database to restore
   when creating a database.

-  Don't clobber the version of ICEkit installed into the base Docker
   image when building a project image.

-  Avoid failing test builds when Coveralls fails to push its update.

-  Add an authors app.

-  You can now define ``help_text`` for a fluent placeholder in
   ``FLUENT_CONTENTS_PLACEHOLDER_CONFIG``.

-  Improved ``ICEkitURLField``, which uses correct ``Page`` queryset.

Backwards incompatible changes:

-  The default command for ``django`` service now starts an interactive
   shell instead of ``supervisord.sh`` (which starts Nginx and
   Gunicorn). Use the new
   ``docker-compose run --rm --service-ports django`` command to shell
   into a new ``django`` container and then manually call
   ``runserver.sh`` or ``supervisord.sh`` instead of
   ``docker-compose up``.

-  The ``entrypoint.sh`` script is now executed via the ``ENTRYPOINT``
   instruction in ``Dockerfile``. You don't need to explicitly include
   it as an argument to ``docker-compose run ...`` commands or in
   ``docker-compose.yml`` services.

-  Move Node modules and Bower components out of ``icekit`` package and
   into project template for simplicity and greater visibility. Add
   ICEkit dependencies to your project ``bower.json`` and
   ``package.json`` files.

-  Remove ``django-supervisor``. We are now using Supervisor directly
   because it uses a lot of memory and is slow to invoke the whole
   Django machinery just to render a ``supervisord.conf`` template
   before starting Supervisor.

   Define additional services in ``docker-compose.yml`` and a Supervisor
   config file (referenced by the ``SUPERVISORD_CONFIG_INCLUDE``
   environment variable) or shell scripts to run additional processes
   interactively.

0.13.1 (2016-09-14)
-------------------

-  Refactored templates so as to only use bootstrap markup when layout
   is intrinsic. Improved markup for some, particularly quote and
   OEmbed.

-  Added instructions covering uninstalling a docker project.

-  Installation improvements.

-  Thumbnail configuration should now be specified in settings, not
   templates.

0.12 (2016-08-30)
-----------------

-  Make project run more consistently without Docker (via ``go.sh``).

-  Refactor docs to provide better onboarding.

-  Fix intermittent cache related test failures.

0.11 (2016-08-29)
-----------------

-  Serve Django with Nginx/Gunicorn under Supervisord, to buffer
   requests, facilitate large file uploads (500MB), and take full
   advantage of multiple CPU cores.

-  The ``SITE_PORT`` setting now represents the public port that the
   site is listening on (Nginx), not the WSGI process (Gunicorn).

-  Use ``initial_data.sql`` dump to bypass old migrations on first run,
   not only when running tests.

-  Use wrapper scripts for program commands, so we can run programs
   consistently in Docker containers of via Supervisord when not using
   Docker.

-  Expose private ports (e.g. Gunicorn, PostgreSQL, Redis) to the host
   on a dynamic port during development.

-  Update the ``Site`` object matching the ``SITE_ID`` setting in a
   post-migrate signal handler with the ``SITE_DOMAIN``, ``SITE_PORT``
   and ``SITE_NAME`` settings.

-  Run celery programs via Supervisord when not using Docker.

-  Configure Docker and non-Docker environments to be more similar so we
   can use more of the same scripts to run.

-  Don't use Redis lock to avoid parallel setup when not using Docker,
   on a single server.

0.10.2 (2016-08-25)
-------------------

-  Run tests in a Docker image on Travis CI and push to Docker Hub on
   success.
-  Test the same settings module in Docker and Tox.
-  Fix broken tests.

0.10.1 (2016-08-24)
-------------------

-  Speed up tests by restoring a database with migrations already
   applied.
-  Fix broken tests.

0.10 (2016-08-23)
-----------------

New:

-  `#3 <https://github.com/ic-labs/django-icekit/pull/3>`__ Include a
   Django project with ICEkit, making it easier to run in development,
   need less boilerplate code, be less likely to diverge over time, and
   easier to keep up-to-date.

-  `#4 <https://github.com/ic-labs/django-icekit/pull/4>`__ Make content
   plugins "portable", making it easier to fork and customise them for a
   project.

Backwards incompatible changes:

-  Make content plugins `portable <topics/portable-apps.md>`__. You will
   need to run an SQL statement for each plugin manually to fix Django's
   migration history when upgrading an existing project.

   ::

       UPDATE django_migrations SET app='icekit_plugins_brightcove' WHERE app='brightcove';
       UPDATE django_migrations SET app='icekit_plugins_child_pages' WHERE app='child_pages';
       UPDATE django_migrations SET app='icekit_plugins_faq' WHERE app='faq';
       UPDATE django_migrations SET app='icekit_plugins_file' WHERE app='file';
       UPDATE django_migrations SET app='icekit_plugins_horizontal_rule' WHERE app='horizontal_rule';
       UPDATE django_migrations SET app='icekit_plugins_image' WHERE app='image';
       UPDATE django_migrations SET app='icekit_plugins_instagram_embed' WHERE app='instagram_embed';
       UPDATE django_migrations SET app='icekit_plugins_map' WHERE app='map';
       UPDATE django_migrations SET app='icekit_plugins_map_with_text' WHERE app='map_with_text';
       UPDATE django_migrations SET app='icekit_plugins_oembed_with_caption' WHERE app='oembed_with_caption';
       UPDATE django_migrations SET app='icekit_plugins_page_anchor' WHERE app='page_anchor';
       UPDATE django_migrations SET app='icekit_plugins_page_anchor_list' WHERE app='page_anchor_list';
       UPDATE django_migrations SET app='icekit_plugins_quote' WHERE app='quote';
       UPDATE django_migrations SET app='icekit_plugins_reusable_form' WHERE app='reusable_form';
       UPDATE django_migrations SET app='icekit_plugins_slideshow' WHERE app='slideshow';
       UPDATE django_migrations SET app='icekit_plugins_twitter_embed' WHERE app='twitter_embed';

0.9 (2016-08-11)
----------------

-  Initial release.
