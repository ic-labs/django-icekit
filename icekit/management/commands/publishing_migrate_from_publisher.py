from django.apps import apps
from django.core.management.base import NoArgsCommand


class Command(NoArgsCommand):
    help = ("One-time migration of a project using `django-model-publisher`"
            " DB fields to ICEKit's 'publishing' equivalents")

    def handle_noargs(self, *args, **options):
        UrlNode = apps.get_model('fluent_pages.UrlNode')
        for node in UrlNode.objects.all():
            # Copy legacy 'publisher' fields to 'publishing' equivalents
            node.publishing_linked = node.publisher_linked
            node.publishing_is_draft = node.publisher_is_draft
            node.publishing_modified_at = node.publisher_modified_at
            node.publishing_published_at = node.publisher_published_at

            # Set `UrlNode.status` based on published status
            if getattr(node, 'publisher_is_draft', True):
                node.status = UrlNode.DRAFT
            else:
                node.status = UrlNode.PUBLISHED

            # Delete/clear legacy 'publisher_linked' field to avoid duplicate
            # key errors for new publishing system, which no longer does all
            # the fancy footwork necessary to handle the legacy `publisher`
            # fields.
            node.publisher_linked = None

            node.save()
