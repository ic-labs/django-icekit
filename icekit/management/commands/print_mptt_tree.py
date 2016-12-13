from optparse import make_option

from django.core.management.base import NoArgsCommand
from django.utils import translation
from django.utils.encoding import smart_text

from fluent_pages.models.db import UrlNode


class Command(NoArgsCommand):
    help = "Print the MPTT tree structure for draft (or published) UrlNodes"
    option_list = (
        make_option(
            '-p', '--published', action='store_true',
            dest='print-published', default=False,
            help="Print the tree for published copies only, not drafts"
        ),
    ) + NoArgsCommand.option_list

    def print_item(self, item):
        if hasattr(item, 'get_draft'):
            published_status_list = ["draft=%d" % item.get_draft().pk]
        else:
            published_status_list = ["draft=%d" % item.pk]

        if not hasattr(item, 'has_been_published'):
            published_status_list.append("unpublishable")
        elif not item.has_been_published:
            published_status_list.append("unpublished")
        else:
            published_status_list.append(
                "published=%d" % item.get_published().pk)

        self.stdout.write(smart_text(
            u"{level_indent}{item} [{url}]{publish_status}".format(
                level_indent=" " * 4 * item._mpttfield('level'),
                item=smart_text(repr(item)),
                url=item._cached_url,
                publish_status=" (%s)" % ', '.join(published_status_list),
            )
        ))

    def print_mptt_tree(self, tree_roots):
        seen_draft_pks = {}
        for root in tree_roots:
            self.print_item(root)
            for item in root.get_descendants():
                if root.is_draft:
                    item_to_print = item.get_draft()
                else:
                    item_to_print = item.get_published()
                    if not item_to_print:
                        continue

                # Avoid re-printing items we have already seen
                draft_pk = item.get_draft().pk
                if draft_pk in seen_draft_pks:
                    continue
                else:
                    seen_draft_pks[draft_pk] = True

                self.print_item(item_to_print)

    def handle_noargs(self, **options):
        draft_only = not options.get('print-published', False)
        self.verbosity = options.get('verbosity', 1)

        translation.activate('en')

        # Find all UrlNode's without parents (root nodes) including only draft
        # or published items, as requested
        tree_roots_qs = UrlNode.objects.filter(
            parent__isnull=True,
            status=draft_only and UrlNode.DRAFT or UrlNode.PUBLISHED,
        )
        self.print_mptt_tree(tree_roots_qs)
