from django.db import migrations


class ObsoleteAppNameInMigrationsTableException(Exception):
    pass


def _assert_and_rename_app_in_migrations(old_app_name, new_app_name):
    def inner(apps, schema_editor):
        with schema_editor.connection.cursor() as cursor:
            cursor.execute(
                "SELECT COUNT(*) FROM django_migrations WHERE app=%s;",
                [old_app_name]
            )
            obsolete_migration_record_count = cursor.fetchone()[0]
            if obsolete_migration_record_count:
                cursor.execute(
                    "UPDATE django_migrations SET app=%s WHERE app=%s;",
                    [new_app_name, old_app_name]
                )

                # Hack to forcibly and immediately commit the above UPDATE
                # command to avoid it being rolled back when this migration
                # fails by raising the exception, or by failing on the next
                # step in the overall migration which is likely with obsolete
                # migration data.
                # See http://stackoverflow.com/a/31253540/4970
                if schema_editor.connection.in_atomic_block:
                    schema_editor.atomic.__exit__(None, None, None)
                schema_editor.connection.commit()

                raise ObsoleteAppNameInMigrationsTableException(
                    "%d migrations existed for obsolete app name '%s' in the"
                    " 'django_migrations` database table. These migrations"
                    " have been renamed to use app name '%s'. Re-run the"
                    " migrate command to apply migrations for the renamed app"
                    % (obsolete_migration_record_count,
                       old_app_name, new_app_name)
                )
    return inner


def RenameAppInMigrationsTable(old_app_name, new_app_name):
    """
    Check whether an obsolete application name `old_app_name` is present in
    Django's `django_migrations` DB table and handle the situation as cleanly
    as possible.

    If there are migrations for the old app name, perform an UPDATE command to
    rename the app in this table so future migration runs will succeed, then
    exit with a `ObsoleteAppNameInMigrationsTableException` to indicate that
    migrations need to be re-run.

    If there are no migrations for the old app name -- e.g. the app has already
    been renamed in the table, or the old pre-rename migrations were never run
    on the DB -- then no action is performed.
    """
    return migrations.RunPython(
        _assert_and_rename_app_in_migrations(old_app_name, new_app_name)
    )
