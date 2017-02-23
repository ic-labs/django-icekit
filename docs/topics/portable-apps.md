# Portable Content Plugin & Page Type Apps

It's important that we try to make the content plugin and page type apps that
ship with ICEkit as generic as possible, so that we can re-use them as-is for
the most common cases, while making it possible to customise when needed.

When we do need to customise, we should be able to simply by copying the entire
app (admin classes, forms, migrations, models, templates, views, etc.) from
ICEkit into a project, and having it work exactly as it did before.

If we can ensure that the database table names don't change and imports don't
break when installing an app from within a project package, this will be easy.

# How to make a portable app

Following these guidelines will make it easy to copy an app into a project when
customisation is required, without complicated database migrations.

  * Dynamically derive the default `AppConfig` class and `AppConfig.name`
    attribute from the module name:

        # __init__.py
        default_app_config = '%s.apps.AppConfig' % __name__

        # apps.py
        from django.apps import AppConfig
        class AppConfig(AppConfig):
            name = '.'.join(__name__.split('.')[:-1])  # Name of package where `apps` module is located

    These values won't break when the app package is copied to a new location.

  * Hardcode the `AppConfig.label` attribute, deriving from the canonical
    `AppConfig.name`. For example, by replacing `.` with `_`:

        # apps.py
        class AppConfig(AppConfig):
            name = ...
            label = 'icekit_page_types_layout_page'

    By default, Django only uses the last component of the app name, which
    might result in labels that are likely to conflict with other apps.

  * Always use relative imports within the app package, not only model imports.

To copy a portable app package into a project, just copy the whole package to a
new location and update your `INSTALLED_APPS` setting.

# How to rename an app label

When making an existing app more portable, things are a little more complicated
when it is already being used by other projects. But we can still do it.

In the app whose label is being updated, make the following changes:

  * Update the `AppConfig.label` attribute or rename the app package.

  * Update the `Meta.app_label` attribute on existing models, if they already
    have a value set.  
    NOTE: You may need to add and set this attribute to `{new app label}`
    in some cases even if it was not already set, see for example
    https://github.com/ic-labs/django-icekit/issues/190 where this was
    necessary to avoid a downstream project from getting confused about
    which app provided a model.

  * Replace any absolute imports within the app with relative imports.

  * If the app package was renamed, expose its modules at their old location
    with a deprecation warning.

  * Add a `db_table: {old app label}` option to all `CreateModel` operations in
    existing migrations, if not already defined, giving the previous app label
    as the value.

  * Run `manage.py makemigrations {app_label}`. Django will detect that the
    `db_table` option has changed and will create a migration to rename the
    table for us.

  * Add the following `RunSQL` operation to the newly created migration:

        migrations.RunSQL("UPDATE django_content_type SET app_label='{new app label}' WHERE app_label='{old app label}';"),

  * Add the following `RenameAppInMigrationsTable` operation as the **first**
    operation in the initial migration for the app, like this:

        # Import from ICEkit utilities
        from icekit.utils.migrations import RenameAppInMigrationsTable

        operations = [
            RenameAppInMigrationsTable({ old app label}, {app label}),
            # Existing operations below here

    This migration operation will check whether the app's has already been
    renamed in Django's migrations table (e.g. with the `UPDATE
    django_migrations` SQL command below) and, if not, it will do this job then
    fail with a clear error message asking you to re-run the migrations now
    that the migration table is corrected.

## Applying the app rename in an existing project

In a project that uses a portable app with an updated app label, make the
following changes:

  * Replace absolute model imports with `get_app()` and `get_model()` calls on
    the app registry.

  * Update absolute imports, if required, to avoid any deprecation warnings.

  * Update the `app_label` argument to `get_*()` calls on the app registry.

  * Update the app label in the `dependencies` and `run_before` attributes in
    existing migrations.

  * Update foreign key and many to many fields in all apps.

  * Ensure that any DB migrations that define foreign key or many to many
    relationships to a renamed app include in their `dependencies` list a
    migration from the renamed app at or after the rename, that is when
    the `AlterTableModel` migration occurs in the renamed app. Without this,
    the project migrations won't always know new name of the renamed app and
    might fail to create or change relationships.

  * Execute the following SQL directly on the database for your renamed apps:

        UPDATE django_migrations SET app='{new app label}' WHERE app='{old app label}';
