# Page Trees and Django MPTT

This document describes how Fluent's page hierarchy tree structure interacts
with and is customised for our publishing and versioning CMS features.

## Overview

Pages in the Fluent CMS – as derived from `UrlNode` – can be arranged in a
tree structure to define a page and URL hierarchy for a site.

The tree structure is authoritatively described by `UrlNode.parent`
relationships, and by corresponding reverse `children` relationship.

Like many Django CMS systems, Fluent uses the [MPTT][django-mptt] utilities
to improve the performance of tree hierarchy lookups and gain tree traversal
and management tools. MPTT derives and stores extra data from the
authoritative `parent`/`children` relationships so it can reconstruct tree
hierarchies with a minimum of DB queries. The additional fields added by
MPTT are:

  * `tree_id` - a unique ID for each top-level tree item and all its
    descendants.
  * `level` - an item's level in the tree, to store the tree level of items
    with the same `tree_id`. Level starts from 0 for the root node, 1 for the
    first level of children etc.
  * left (actually `lft` in Fluent) - an ID indicating an item's position in a
    tree, such that all items with the same `tree_id` but a lesser left value
    are ancestors or prior siblings.
  * right (actually `rght` in Fluent) - an ID indicating an item's position in
    a tree, such that all items with the same `tree_id` but a greater right
    value are descendants or following siblings

In addition to the standard MPTT utilities, Fluent customises and builds on
the MPTT features to manage a cached URL field `UrlNode_Translation._cached_url`
(also exposed as the translated field `UrlNode._cached_url`) which stores
the absolute URL path for all pages – based on the `slug` value of a page
translation and all its ancestors – for quick retrieval and URL matching.

### Problems with MPTT

Unfortunately we (and others) have found the MPTT utilities and to be fragile
and the DB representation to be easily prone to corruption.

Because the MPTT fields are essentially a cached representation of the real
tree structure, if these field values get out-of-date compared to the real
`parent`/`children` relationships then MPTT's notion of the tree structure
becomes incorrect. And because the MPTT fields are a highly abstracted version
of the tree structure data, even small errors can completely break the tree
hierarchy as reported by the MPTT methods. Any small errors also multiply
quickly as further tree change operations performed by MPTT methods affect
smaller or greater portions of the tree than they should.

It is not at all difficult to end up with a corrupted MPTT tree, and at this
point the MPTT library offers few tools for resolving the issues other than
rebuilding from scratch its tree representation fields from the real `parent`
relationships.

Our difficulties with MPTT are further complicated by our major CMS feature
additions for Publishing and Versioning, which need to manage or duplicate data
in ways that are not expected by MPTT and therefore are even more likely to
lead to corruption of the tree. Our customisations and work-arounds for these
situations is covered in more detail below.

Fortunately, Fluent CMS does not seem to use MPTT data very heavily for
important features. Despite numerous lingering but unrecognised problems with
how MPTT interacts with our publishing and versioning features, relatively few
problems surfaced for customers like SFMOMA. Where problems did arise, they
were mostly hard failures when modifying the tree structure or slug values for
pages in the CMS, or inconsistencies in the page structure showing in the
admin, rather than public-facing failures.

## MPTT and Publishing

Our [publishing implementation](../topics/publishing.md) is based on having up
to two copies of every publishable item: a draft copy which has the latest data
and is visible in the CMS admin, and a published copy which was cloned from a
current or prior draft copy and shares all its data but is handled differently
by the system. In particular, the `parent` relationship for both draft and
published copies always points to a **draft** copy in the system, so that
child/descendant items can be published before their ancestors (as well for
data hygiene and *relative* simplicity).

This approach tends to clash with MPTT's tree structure caching because we
often have two copies of an item – a draft copy and a published copy – yet
these two copies logically are in the exact same location in the overall tree
hierarchy, and also often have identical URL paths to be cached. MPTT, on the
other hand, doesn't know about the draft/published distinction and wants to
manage both copies as separate items. This clash led to issues where MPTT got
confused, and corrupted, and then when we naively performed an MPTT tree
rebuild while MPTT was unaware of our publishing system things only got worse.

To solve problems with MPTT's interactions with publishing we have customised
MPTT in two key ways.

### MPTT Operates on Draft Tree Only

We have customised MPTT to only ever operate on the tree structure of **draft**
items, not published copies.

  * The `rebuild_page_tree` MPTT management command is re-implemented in SFMOMA
    and adjusted to operate only on draft items.

  * The MPTT methods `get_root`, `get_descendants`, and `get_ancestors` are
    replaced for publishable items via `SFMOMAPublisherContributeToClassManager`
    to return only the root, descendants, or ancestors with the same
    draft-or-published status as the current item.

The idea behind these changes is that – given that admin CMS operations are
performed only on draft copies of items – MPTT should be restricted to seeing
and managing the tree only for draft items.

### Immediately Sync Draft Tree Changes to Published Copies

Given that MPTT is restricted to managing draft copies by our customisations
described above, we are left with the question of what to do with published
copies of draft items?

Our solution is to always and immediately synchronise tree structure changes
made to draft items to their corresponding published copies. This means that
we can exclude published copies from MPTT tree management in general, but
still ensure the published copies are available in MPTT lookups when it is
time to generate tree-derived data such as the hierarchical cached URLs that
are vital to make pages routable and thus publicly accessible.

Syncing draft tree structure data to published copies involves cloning the
the authoritative `parent` tree structure relationship field, along with the
MPTT tree_id/left/right/level fields.

The following customisations sync draft tree structure data to published
copies:

  * The `sync_draft_page_tree` management command syncs tree data for all
    draft items in the system in bulk, and report on the changes made (if any).

  * The `sync_mptt_tree_fields_from_draft_to_published_post_save` post-save
    signal handler in *sfmoma/models.py* copies a draft item's tree structure
    changes to its corresponding published copy.

  * Both of the above also trigger the `update_fluent_cached_urls` function to
    update the cached URLs for any items affected by tree structure changes,
    to keep the URLs up-to-date for changed items and their descendants.

The immediate syncing solution has some interesting implications we need to
be aware of, and communicate to users:

  * If a user changes the tree location of a draft item in the CMS admin, that
    change is **immediately** applied to the published/public copies. In other
    words, there is no *publish* step to make tree structure changes public.

  * Although closely related to the tree structure, changes to an item's
    `slug` field do need to be published to be made public. Unless/until a slug
    change is published, the change will apply only to the draft URL hierarchy
    not to the publicly-visible published URL hierarchy.

  * If the user changes both the tree location and the slug of a draft item in
    the CMS admin, the tree location change will become public immediately but
    the slug change will not become public unless/until it is published.

## MPTT and Versioning

Our versioning system allows site admins to view and restore historical
versions of pages to roll back to earlier data. This feature also clashes
badly with standard MPTT because historical cached MPTT data is likely to
get out-of-date with the correct cached tree data very quickly, and if the
outdated data is then restored MPTT's tree can get corrupted in particularly
nasty ways. This bit us in an issue where restoring historical data led
two completely different trees (according to the authoritative `parent`
relationship) having the same MPTT `tree_id`, which caused every MPTT tree
traversal or update operation on either tree to fail.

We solve this issue by ignoring historical MPTT data altogether when
restoring old versions of items, and instead selectively applying only the
historical tree structure data where doing so makes sense and is safe. In
particular:

  * The historical MPTT tree data fields are completely ignored when reverting
    or recovering items

  * When an existing item is reverted, its current location in the tree (i.e.
    its `parent`) and all its MPTT field values are kept completely unchanged
    by the revert process. This keeps the tree data consistent, and also
    avoids any unexpected changes to the published/public site that would
    happen if a revert changed the tree structure and this change was
    immediately synced.

  * When a deleted item is recovered, it is inserted into the tree structure
    under its original `parent` if possible, otherwise it becomes a root node
    (top-level page).

Unfortunately while the above description sounds relatively simple, actually
applying this logic is not at all simple. It involves painstakingly working
around and against MPTT's automatic tree management features: essentially
fighting with MPTT every step of the way. We tried alternatives to this
approach without success, including more sensible but fruitless approaches
like not storing MPTT data at all in historical versions (produced invalid
historical data), or disabling MPTT's automatic tree management features
during revert operations (not possible for polymorphic trees).

You can find the code that does this work in MPTT-specific sections of the
`pre_revert_view` and `post_revert_view` functions that handle pre- and
post-processing of the revision form view.

## MPTT Tree Fixes and Monitoring

To fix corrupted MPTT tree data and to monitor
tree data over time to identify and fix tree-related problems, we have tools
to manage and log the page tree:

  * The `print_mptt_tree` management command prints out a textual
    representation of the site's draft/published trees according to MPTT's
    `get_descendants` method, along with extra information such as the draft
    and published PKs for each item in the trees and the published status.
    This printout is particularly useful for capturing and diffing
    before-and-after versions of trees according to MPTT.

  * The `sync_draft_page_tree` management command syncs tree data for all
    draft items in the system in bulk, and report on the changes made (if any).
    If run with the `--dry-run` switch it will not actually make any changes,
    and will just print out changes it would have made. This command is useful
    initially to get the MPTT tree data in order for SFMOMA, and in the longer
    term as a monitoring mechanism to check whether the draft and published
    tree structures are getting out of sync.

Read on for some recipes for checking the status and validity of tree
structure data.

### Check MPTT Tree Structure is Valid for Draft Items

To check that the data MPTT has cached to represent the page tree structure
is up-to-date and valid, use the `print_mptt_tree` management command before
and after rebuilding the (draft-only) MPTT tree:

 1. Run the print_mptt_tree management command for draft trees to capture the
    tree state before the tree rebuilds:

    $ manage.py print_mptt_tree > "1a - mptt.draft.before.txt"

 2. Run the rebuild_page_tree management command to fix the draft MPTT tree data:

    $ manage.py rebuild_page_tree > "2 - mptt.rebuild_page_tree.txt"

 3. Run the print_mptt_tree for draft tree to capture the tree state after
    the draft tree rebuild

    $ manage.py print_mptt_tree > "3 - mptt.draft.after.txt"

 4. Diff/compare the files "1a - mptt.draft.before.txt" and
    "3 - mptt.draft.after.txt" to look for changes.

### Check MPTT Tree Structure Sync is Working for Published Items

To check that the MPTT tree data is being properly synced between draft and
published items you can run the `sync_draft_page_tree` management command
with the `--dry-run` switch to print out, but not perform, the changes
necessary to bring the two into line.

 1. Run the `sync_draft_page_tree` management command in dry-run mode to log
    any tree structure differences between the draft and published trees:

    $ manage.py sync_draft_page_tree --dry-run > "4 - mptt.sync-draft-to-published.txt"

 2. Check the output file for unexpected differences. Only fields that differ
    between the draft and published trees are printed.

There shouldn't be any changes necessary, except perhaps for some trivial
(and irrelevant for SFMOMA) changes to sibling ordering within levels of
the tree.

In particular, look out for any changes to `_cached_url` fields which would
indicate that not only are the tree structures different somehow, but the
publicly-accessible URL in the published tree is incorrect.

### Check MPTT Tree Structure Sync is Identical between Draft and Published Items

An alternative way of checking that MPTT data is properly synced between
draft and published trees is to compare the outputs of the `print_mptt_tree`
command for the draft and the published trees.

 1. Run the print_mptt_tree management command for both draft and published
    trees:

    $ manage.py print_mptt_tree > "1a - mptt.draft.before.txt"
    $ manage.py print_mptt_tree --published > "1b - mptt.published.before.txt"

 2. Diff/compare the files "1a - mptt.draft.before.txt" and
    "1b - mptt.published.before.txt" and look for any differences other than
    unpublished pages, which should only appear in the first file.

The output of these commands is a quite noisy for this comparison, but can
be quickly cross-checked with the page tree as shown in the site admin e.g.
at */kiosk/fluent_pages/page/*, to perform a quick visual check.

### Automated MPTT Tree Monitoring (TODO)

We should add cronjob tasks on production to regularly print the tree
structures for logging purposes, and check whether the draft and published
trees remain in sync during real-world use.

The following scheduled jobs would be ideal.

#### Daily Log of Tree Structure Changes

 1. Run `print_mptt_tree` command and direct output to a date-stamped file
 2. Run `print_mptt_tree --published` command and direct output to a
    date-stamped file

#### Daily Log of Tree Structure Corruption

 1. Run `print_mptt_tree` command and capture "before" output
 2. Run the `rebuild_page_tree` management command – within a transaction
    that is always rolled back – to fix any draft tree problems
 3. Run `print_mptt_tree` command and capture "after" output
 4. Diff/compare before and after MPTT tree printouts to check for
    non-trivial changes
 5. Notify site admins if changes indicative of MPTT tree corruption are found.

NOTE: We do not yet have a way to run the `rebuild_page_tree` management
command in a transaction context that can be rolled back.

[django-mptt]: https://github.com/django-mptt/django-mptt
