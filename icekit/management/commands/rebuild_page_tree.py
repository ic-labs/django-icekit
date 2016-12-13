from optparse import make_option

from django.core.management.base import NoArgsCommand
from django.utils.encoding import smart_text

from fluent_pages import appsettings
from fluent_pages.models.db import UrlNode_Translation, UrlNode


class Command(NoArgsCommand):
    """
    Update the tree, rebuild the translated URL nodes.
    """
    help = "Update the cached_url for the translated URL node tree"
    option_list = (
        make_option(
            '-n', '--dry-run', action='store_true', dest='dry-run', default=False,
            help="Only list what will change, don't make the actual changes."
        ),
        make_option(
            '-m', '--mptt-only', action='store_true', dest='mptt-only', default=False,
            help="Only fix the MPTT fields, leave URLs unchanged."
        ),
    ) + NoArgsCommand.option_list

    def handle_noargs(self, **options):
        """
        By default this function runs on all objects.

        As we are using a publishing system it should only update draft
        objects which can be modified in the tree structure.

        Once published the tree preferences should remain the same to
        ensure the tree data structure is consistent with what was
        published by the user.
        """
        is_dry_run = options.get('dry-run', False)
        mptt_only = options.get('mptt-only', False)
        slugs = {}
        overrides = {}

        # MODIFIED
        # This was modified to filter draft objects only.
        # ORIGINAL LINE -> `parents = dict(UrlNode.objects.values_list('id', 'parent_id'))`
        parents = dict(
            UrlNode.objects.filter(status=UrlNode.DRAFT).values_list('id', 'parent_id')
        )
        # END MODIFIED

        self.stdout.write("Updated MPTT columns")
        if is_dry_run and mptt_only:
            # Can't really do anything
            return

        if not is_dry_run:
            # Fix MPTT first, that is the basis for walking through all nodes.

            # MODIFIED
            # Original line -> `UrlNode.objects.rebuild()`
            # The `rebuild` function works on the manager. As we need to filter the queryset first
            # it does not play nicely. The code for `rebuild` was brought in here and modified to
            # work with the current context.

            # Get opts from `UrlNode` rather than `self.model`.
            opts = UrlNode._mptt_meta

            # Add a queryset parameter will draft objects only.
            qs = UrlNode.objects._mptt_filter(
                qs=UrlNode.objects.filter(status=UrlNode.DRAFT),
                parent=None
            )
            if opts.order_insertion_by:
                qs = qs.order_by(*opts.order_insertion_by)
            pks = qs.values_list('pk', flat=True)

            # Obtain the `rebuild_helper` from `UrlNode.objects` rather than `self`.
            rebuild_helper = UrlNode.objects._rebuild_helper
            idx = 0
            for pk in pks:
                idx += 1
                rebuild_helper(pk, 1, idx)
            # END MODIFIED

            self.stdout.write("Updated MPTT columns")
            if mptt_only:
                return

            self.stdout.write("Updating cached URLs")
            self.stdout.write("Page tree nodes:\n\n")

        col_style = u"| {0:6} | {1:6} | {2:6} | {3}"
        header = col_style.format("Site", "Page", "Locale", "URL")
        sep = '-' * (len(header) + 40)
        self.stdout.write(sep)
        self.stdout.write(header)
        self.stdout.write(sep)

        # MODIFIED
        # Modified to add the filter for draft objects only.
        for translation in UrlNode_Translation.objects.filter(
            master__status=UrlNode.DRAFT
        ).select_related('master').order_by(
            'master__parent_site__id', 'master__tree_id', 'master__lft', 'language_code'
        ):
            # END MODIFIED
            slugs.setdefault(translation.language_code, {})[translation.master_id] = translation.slug
            overrides.setdefault(translation.language_code, {})[translation.master_id] = translation.override_url

            old_url = translation._cached_url
            try:
                new_url = self._construct_url(translation.language_code, translation.master_id, parents, slugs, overrides)
            except KeyError:
                if is_dry_run:
                    # When the mptt tree is broken, some URLs can't be correctly generated yet.
                    self.stderr.write("Failed to determine new URL for {0}, please run with --mptt-only first.".format(old_url))
                    return
                raise

            if old_url != new_url:
                translation._cached_url = new_url
                if not is_dry_run:
                    translation.save()

            if old_url != new_url:
                self.stdout.write(smart_text(u"{0}  {1} {2}\n".format(
                    col_style.format(translation.master.parent_site_id, translation.master_id, translation.language_code, translation._cached_url),
                    "WILL CHANGE from" if is_dry_run else "UPDATED from",
                    old_url
                )))
            else:
                self.stdout.write(smart_text(col_style.format(
                    translation.master.parent_site_id, translation.master_id, translation.language_code, translation._cached_url
                )))


    def _construct_url(self, language_code, child_id, parents, slugs, overrides):
        fallback = appsettings.FLUENT_PAGES_LANGUAGES.get_fallback_language(language_code)

        breadcrumb = []
        cur = child_id
        while cur is not None:
            breadcrumb.insert(0, cur)
            cur = parents[cur]

        url_parts = ['']
        for id in breadcrumb:
            try:
                # Resets url_parts
                override = overrides[language_code][id]
                if override:
                    url_parts = [override]
                    continue
            except KeyError:
                pass
            try:
                url_parts.append(slugs[language_code][id])
            except KeyError:
                url_parts.append(slugs[fallback][id])

        return (u'/'.join(url_parts) + u'/').replace('//', '/')
