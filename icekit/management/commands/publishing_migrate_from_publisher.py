from django.apps import apps
from django.core.management.base import NoArgsCommand
from django.db import connection

from fluent_pages.models.db import UrlNode

from icekit.publishing.utils import get_publishable_models


class Command(NoArgsCommand):
    help = ("One-time migration of a project using `django-model-publisher`"
            " DB fields to ICEKit's 'publishing' equivalents")

    def handle_noargs(self, *args, **options):
        publishable_models = get_publishable_models()
        count = len(publishable_models)
        for offset, model in enumerate(publishable_models, 1):
            print("Migrating publisher => publishing for %s (%d/%d)"
                  % (model, offset, count))

            # Try and do a simple and fast in-DB bulk update query first, for
            # cases where the legacy and new fields are in the same DB table
            try:
                cursor = connection.cursor()
                cursor.execute(
                    """
                    UPDATE %s
                       SET publishing_linked_id = publisher_linked_id,
                           publishing_is_draft = publisher_is_draft,
                           publishing_modified_at = publisher_modified_at,
                           publishing_published_at = publisher_published_at
                    """ % (model._meta.db_table)
                )
                continue
            except Exception, ex:
                pass

            # Second, try an in-DB bulk update for models that are subclasses
            # of `UrlNode` and for which the legacy publisher fields are in
            # the `UrlNode` DB table.
            if issubclass(model, UrlNode):
                try:
                    cursor = connection.cursor()
                    cursor.execute(
                        """
                        UPDATE {table}
                           SET publishing_linked_id = u.publisher_linked_id,
                               publishing_is_draft = u.publisher_is_draft,
                               publishing_modified_at = u.publisher_modified_at,
                               publishing_published_at = u.publisher_published_at
                          FROM {urlnode_table} AS u
                         WHERE u.id = {table}.{pk_col}
                        """.format(pk_col=model._meta.pk.column,
                                   table=model._meta.db_table,
                                   urlnode_table=UrlNode._meta.db_table)
                    )
                    continue
                except Exception, ex:
                    pass

            # Finally, try doing the data migration with Django model
            # instances if we get this far. This is very slow, but works
            # for models where the publishing fields are defined on
            # a superclass not the exact model.
            publisher_fields_by_pk = {}

            # Lookup legacy 'publisher' fields with direct DB query
            try:
                cursor = connection.cursor()
                cursor.execute(
                    """
                    SELECT %s,
                        publisher_linked_id,
                        publisher_is_draft,
                        publisher_modified_at,
                        publisher_published_at
                    FROM %s
                    """ % (model._meta.pk.column, model._meta.db_table)
                )
            except Exception, ex:
                print("WARNING: Could not migrate data for %s" % model)
                continue

            for row in cursor.fetchall():
                publisher_fields_by_pk[row[0]] = row[1:]

            for item in model.objects.all():
                publisher_fields = publisher_fields_by_pk[item.pk]
                # Copy legacy 'publisher' fields to 'publishing' equivalents
                item.publishing_linked_id = publisher_fields[0]
                item.publishing_is_draft = publisher_fields[1]
                item.publishing_modified_at = publisher_fields[2]
                item.publishing_published_at = publisher_fields[3]

                # Set `UrlNode.status` based on published status
                if getattr(item, 'publisher_is_draft', True):
                    item.status = UrlNode.DRAFT
                else:
                    item.status = UrlNode.PUBLISHED

                item.save()

        # Finally, set `UrlNode.status` field to appropriate value for all
        # nodes that implement ICEKit publishing, or at least have the DB field
        for n in UrlNode.objects.all():
            # Skip nodes that don't have ICEKit Publishing DB fields
            if not hasattr(n, 'publishing_is_draft'):
                continue
            if n.publishing_is_draft and n.status != UrlNode.DRAFT:
                UrlNode.objects.filter(pk=n.pk).update(
                    status=UrlNode.DRAFT)
            if not n.publishing_is_draft and n.status != UrlNode.PUBLISHED:
                UrlNode.objects.filter(pk=n.pk).update(
                    status=UrlNode.PUBLISHED)
