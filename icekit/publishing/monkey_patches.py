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


# Patch to override Django 1.8's default `get_candidate_relations_to_delete`
# function to make it include proxy ancestor models, not just concrete parent
# models, when building a set of models to check for relationships for
# deletion.
# This patch replaces the function with a direct copy, except with our custom
# behaviour in the middle.
def patch_django_18_get_candidate_relations_to_delete(opts):
    from itertools import chain
    # Collect models that contain candidate relations to delete. This may include
    # relations coming from proxy models.
    candidate_models = {opts}
    candidate_models = candidate_models.union(opts.concrete_model._meta.proxied_children)

    # PATCH: Find all relevant ancestor proxy models, working down from the
    # top- most parent concrete models, and include as candidates with
    # interesting relationships.
    for parent in opts.get_parent_list():
        for pc_opts in parent._meta.proxied_children:
            if issubclass(opts.model, pc_opts.model):
                candidate_models.add(pc_opts)
    # END OF PATCH

    # For each model, get all candidate fields.
    candidate_model_fields = chain.from_iterable(
        opts.get_fields(include_hidden=True) for opts in candidate_models
    )
    # The candidate relations are the ones that come from N-1 and 1-1 relations.
    # N-N  (i.e., many-to-many) relations aren't candidates for deletion.
    return (
        f for f in candidate_model_fields
        if f.auto_created and not f.concrete and (f.one_to_one or f.one_to_many)
    )


def APPLY_patch_django_18_get_candidate_relations_to_delete():
    from django.db.models import deletion
    # Check for method available in Django 1.8+ but not before
    if hasattr(deletion, 'get_candidate_relations_to_delete'):
        deletion.get_candidate_relations_to_delete = \
            patch_django_18_get_candidate_relations_to_delete


# Patch to extend the Django 1.7 Collection.collect method that collects
# objects and their relationships for deletion, to fix the process so that
# reverse FK relationships on proxy ancestor objects are included in the
# deletion: #339.  This works around a Django core bug, see issue #18012 [1]
# and related issues #23076 [2] and a potential fix to Django master [3] which
# might get back- ported if we're lucky (though probably not).
#
# [1]: https://code.djangoproject.com/ticket/18012
# [2]: https://code.djangoproject.com/ticket/23076
# [3]: https://github.com/django/django/pull/5378
from django.db.models import DO_NOTHING


def patch_django_17_collector_collect(self, objs, *args, **kwargs):
    # Call original collect to do the standard Django work
    self._original_collect(objs, *args, **kwargs)
    # Collect objects via M2M relationships to proxy models
    if not objs or not kwargs.get('collect_related', True):
        return
    for model in [o._meta.model for o in objs]:
        for proxy_ancestor_cls in get_proxy_ancestor_classes(model):
            opts = proxy_ancestor_cls._meta
            for rel_obj in opts.get_all_related_objects(
                    local_only=True, include_hidden=True):
                rel = rel_obj.field.rel
                if not rel:
                    continue
                if not rel.multiple:
                    continue
                if rel.to != proxy_ancestor_cls:
                    continue
                if rel.on_delete == DO_NOTHING:
                    continue
                fk_f = rel_obj.field
                sub_objs = fk_f.model._base_manager.using(self.using) \
                    .filter(**{"%s__in" % fk_f.name: objs})
                if self.can_fast_delete(sub_objs, from_field=fk_f):
                    self.fast_deletes.append(sub_objs)
                elif sub_objs:
                    fk_f.rel.on_delete(self, fk_f, sub_objs, self.using)


def get_proxy_ancestor_classes(klass):
    """
    Return a set containing all the proxy model classes that are ancestors
    of the given class.

    NOTE: This implementation is for Django 1.7, it might need to work
    differently for other versions especially 1.8+.
    """
    proxy_ancestor_classes = set()
    for superclass in klass.__bases__:
        if hasattr(superclass, '_meta') and superclass._meta.proxy:
            proxy_ancestor_classes.add(superclass)
        proxy_ancestor_classes.update(
            get_proxy_ancestor_classes(superclass))
    return proxy_ancestor_classes


def APPLY_patch_django_17_collector_collect():
    from django.db.models import deletion
    # Check for method available in Django 1.8+ but not before
    if not hasattr(deletion, 'get_candidate_relations_to_delete'):
        deletion.Collector._original_collect = deletion.Collector.collect
        deletion.Collector.collect = patch_django_17_collector_collect
