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

  * Manually derive the `AppConfig.label` attribute from `AppConfig.name`,
    e.g. by replacing `.` with `_`.

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

  * Replace any absolute imports within the app with relative imports.

  * If the app package was renamed, expose its modules at their old location
    with a deprecation warning.

  * Add a `db_table: {old app label}` option to all `CreateModel` operations in
    existing migrations, if not already defined, giving the current app label
    as the value.

  * Run `manage.py makemigrations {app_label}`. Django will detect that the
    `db_table` option has changed and will create a migration to rename the
    table for us.

  * Add the following `RunSQL` operation to the newly created migration:

        migrations.RunSQL("UPDATE django_content_type SET app_label='{new app label}' WHERE app_label='{old app label}';"),

In a project that uses a portable app with an updated app label, make the
following changes:

  * Replace absolute model imports with `get_app()` and `get_model()` calls on
    the app registry.

  * Update absolute imports, if required, to avoid any deprecation warnings.

  * Update the `app_label` argument to `get_*()` calls on the app registry.

  * Update the app label in the `dependencies` and `run_before` attributes in
    existing migrations.

  * Update foreign key and many to many fields in all apps.

  * Execute the following SQL diretly on the database for your renamed apps:

        UPDATE django_migrations SET app='{new app label}' WHERE app='{old app label}';
