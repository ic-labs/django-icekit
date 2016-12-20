from optparse import make_option

from django.core.management.base import NoArgsCommand
from django.utils import translation
from django.utils.encoding import smart_text

from fluent_pages.models.db import UrlNode

from icekit.publishing.models import \
    sync_mptt_tree_fields_from_draft_to_published


class Command(NoArgsCommand):
    help = "Resync MPTT tree data and cached URLs for published page copies"
    option_list = (
        make_option(
            '-n', '--dry-run', action='store_true', dest='dry-run',
            default=False,
            help="Only list what will change, don't make the actual changes."
        ),
        make_option(
            '-f', '--force-update-cached-urls', action='store_true',
            dest='force-update-cached-urls',
            default=False,
            help="Update cached URLs"
        ),
    ) + NoArgsCommand.option_list

    def log(self, msg, at_verbosity=1):
        if self.verbosity >= at_verbosity:
            self.stdout.write(smart_text(msg))

    def sync_draft_copy_tree_attrs_to_published_copy(
            self, drafts_qs, is_dry_run=False, force_update_cached_urls=False):
        for draft in drafts_qs:
            published_copy = getattr(draft, 'publishing_linked', None)
            if not published_copy:
                continue
            change_report = sync_mptt_tree_fields_from_draft_to_published(
                draft,
                dry_run=is_dry_run,
                force_update_cached_urls=force_update_cached_urls)
            if not change_report:
                continue
            for change in change_report:
                item, description, old_value, new_value = change
                if old_value != new_value:
                    item_repr = smart_text(repr(item))
                    self.log(u"%s %s => %s (was %s)" % (
                        item_repr, description, new_value, old_value))

    def handle_noargs(self, **options):
        is_dry_run = options.get('dry-run', False)
        force_update_cached_urls = options.get(
            'force-update-cached-urls', False)
        self.verbosity = options.get('verbosity', 1)

        translation.activate('en')

        drafts_qs = UrlNode.objects.filter(status=UrlNode.DRAFT)
        self.sync_draft_copy_tree_attrs_to_published_copy(
            drafts_qs,
            is_dry_run=is_dry_run,
            force_update_cached_urls=force_update_cached_urls)
