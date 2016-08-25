# Changelog

## 0.10.2 (25 August 2016)

  * Run tests in a Docker image on Travis CI and push to Docker Hub on success.
  * Test the same settings module in Docker and Tox.
  * Fix broken tests.

## 0.10.1 (24 August 2016)

  * Speed up tests by restoring a database with migrations already applied.
  * Fix broken tests.

## 0.10 (23 August 2016)

New:

  * [#3](https://github.com/ic-labs/django-icekit/pull/3)
    Include a Django project with ICEkit, making it easier to run in
    development, need less boilerplate code, be less likely to diverge over
    time, and easier to keep up-to-date.

  * [#4](https://github.com/ic-labs/django-icekit/pull/4)
    Make content plugins "portable", making it easier to fork and customise
    them for a project.

Backwards incompatible changes:

  * Make content plugins [portable](portable-apps.md). You will need to run an
    SQL statement for each plugin manually to fix Django's migration history
    when upgrading an existing project.

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

## 0.9 (11 August 2016)

  * Initial release.
