# Replace default `fluent_pages.adminuri.urlnodechildadmin.UrlNodeAdminForm`
# clean method implementation with an alternative version that knows about
# the quirky way publishing is done -- with near-duplicate objects that share
# slug and URL and tree_id but which don't actually clash because only the
# published or draft items are relevant depending on context (published for
# public site, draft for site admin).
#
# In short, this patched method permits creation and saving of items with
# clashing URL paths as long as the clash is only between publish/draft
# versions of the same notional item.

from copy import copy

from django.utils.translation import gettext_lazy as _
from fluent_pages.adminui.urlnodechildadmin import UrlNodeAdminForm
from fluent_pages.models import UrlNode, UrlNode_Translation


def patch_urlnodeadminform_clean_for_publishable_items(self):
    # Store original cleaned data from superclass of UrlNodeAdminForm, which
    # may contain values the original `UrlNodeAdminForm.clean` removes
    original_cleaned_data = copy(super(UrlNodeAdminForm, self).clean())

    # Invoke the original `UrlNodeAdminForm.clean`
    cleaned_data = self._original_clean()

    # This patch is only necessary for admins of publishable items.
    if 'publishing_linked' not in self._meta.model._meta.get_all_field_names():
        return cleaned_data

    # If a duplicate slug error is reported, make sure it is *really*
    # a duplicate slug instead of just a slug value shared between the
    # published and draft versions of a publishable item. This section
    # duplicates the relevant logic from the original clean method.
    duplicate_slug_error = self.error_class([
        _('This slug is already used by an other page at the same level.')
    ])
    if self._errors.get('slug') == duplicate_slug_error:
        # Get other node translations and parent for item
        other_translations = UrlNode_Translation.objects.all()
        if self.instance and self.instance.id:
            other_translations = other_translations.exclude(
                master_id=self.instance.id)
            try:
                parent = UrlNode.objects.non_polymorphic().get(
                    children__pk=self.instance.id)
            except UrlNode.DoesNotExist:
                parent = None
        else:
            parent = cleaned_data['parent']
        # What will the node's URL will be based on the new slug
        new_slug = original_cleaned_data['slug']
        if parent:
            new_url = '%s%s/' % (parent._cached_url, new_slug)
        else:
            new_url = '/%s/' % new_slug
        # Now check that any nodes with a duplicate final URL that is not just
        # a published version of this item, in which case we can ignore the
        # clash. We detect such items using their `tree_id`, which is shared
        # between draft/published items but not across items.
        real_url_clash_qs = other_translations \
            .filter(_cached_url=new_url) \
            .exclude(master__tree_id=self.instance.tree_id)
        if not real_url_clash_qs.count():
            del self._errors['slug']
            cleaned_data['slug'] = original_cleaned_data['slug']

    return cleaned_data


def APPLY_patch_urlnodeadminform_clean_for_publishable_items():
    UrlNodeAdminForm._original_clean = UrlNodeAdminForm.clean
    UrlNodeAdminForm.clean = patch_urlnodeadminform_clean_for_publishable_items
