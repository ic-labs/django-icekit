from django.apps import AppConfig, apps
from django.core.exceptions import MultipleObjectsReturned

from fluent_pages import appsettings
from fluent_pages.models import UrlNode

from mptt.models import MPTTModel

from .managers import PublishingUrlNodeManager
from .models import PublishingModel


def monkey_patch_override_method(klass):
    """
    Override a class method with a new version of the same name. The original
    method implementation is made available within the override method as
    `_original_<METHOD_NAME>`.
    """
    def perform_override(override_fn):
        fn_name = override_fn.__name__
        original_fn_name = '_original_' + fn_name
        # Override class method, if it hasn't already been done
        if not hasattr(klass, original_fn_name):
            original_fn = getattr(klass, fn_name)
            setattr(klass, original_fn_name, original_fn)
            setattr(klass, fn_name, override_fn)
    return perform_override


class AppConfig(AppConfig):
    # Name of package where `apps` module is located
    name = '.'.join(__name__.split('.')[:-1])

    def __init__(self, *args, **kwargs):
        self.label = self.name.replace('.', '_')
        super(AppConfig, self).__init__(*args, **kwargs)

    def ready(self):
        # Monkey-patch workaround for class inheritance weirdness where our
        # model methods and attributes are getting clobbered by versions higher
        # up the inheritance hierarchy.
        # TODO Find a way to avoid this monkey-patching hack
        for model in apps.get_models():
            # Skip any models that don't have publishing features
            if not issubclass(model, PublishingModel):
                continue

            if issubclass(model, UrlNode):

                PublishingUrlNodeManager().contribute_to_class(
                    model, 'publishing_objects')

                @monkey_patch_override_method(model)
                def _make_slug_unique(self, translation):
                    """
                    Custom make slug unique checked.
                    :param self: The object to which the slug is or will be
                    associated.
                    :param translation: The particular translation of the slug.
                    :return: None
                    """
                    original_slug = translation.slug
                    count = 1
                    while True:
                        exclude_kwargs = {
                            'pk__in': [],
                        }
                        if self:
                            exclude_kwargs['pk__in'].append(self.pk)

                        if self.publishing_linked_id:
                            exclude_kwargs['pk__in'].append(self.publishing_linked_id)

                        url_nodes = UrlNode.objects.filter(
                            parent=self.parent_id,
                            translations__slug=translation.slug,
                            translations__language_code=translation.language_code
                        ).exclude(**exclude_kwargs).non_polymorphic()

                        if appsettings.FLUENT_PAGES_FILTER_SITE_ID:
                            url_nodes = url_nodes.parent_site(self.parent_site_id)

                        if not url_nodes.exists():
                            break

                        count += 1
                        translation.slug = '%s-%d' % (original_slug, count)

            if issubclass(model, MPTTModel):

                @monkey_patch_override_method(model)
                def get_root(self):
                    """
                    Replace default implementation of `mptt.models.MPTTModel.get_root`
                    with a version that returns the root of either published or draft
                    items, as appropriate for this item.

                    In other words: return the published root if this item is
                    published; return the draft root if this item is a draft.
                    """
                    if self.is_root_node() \
                            and type(self) == self._tree_manager.tree_model:
                        return self

                    root_qs = self._tree_manager._mptt_filter(
                        tree_id=self._mpttfield('tree_id'),
                        parent=None,
                    )
                    # Try normal approach first, in case it works
                    try:
                        return root_qs.get()
                    except MultipleObjectsReturned:
                        # Nope, we got both draft and published copies as root
                        pass

                    # Sort out this mess manually by grabbing the first root candidate
                    # and converting it to draft or published copy as appropriate.
                    if self.is_draft:
                        return root_qs.first().get_draft()
                    else:
                        return root_qs.first().get_published()

                @monkey_patch_override_method(model)
                def get_descendants(self, include_self=False, ignore_publish_status=False):
                    """
                    Replace `mptt.models.MPTTModel.get_descendants` with a version that
                    returns only draft or published copy descendants, as appopriate.
                    """
                    qs = self._original_get_descendants(include_self=include_self)
                    if not ignore_publish_status:
                        return type(self).objects.filter(
                            pk__in=qs.values_list('pk', flat=True),
                            publishing_is_draft=self.publishing_is_draft)
                    return qs

                @monkey_patch_override_method(model)
                def get_ancestors(self, ascending=False, include_self=False,
                                  ignore_publish_status=False):
                    """
                    Replace `mptt.models.MPTTModel.get_ancestors` with a version that
                    returns only draft or published copy ancestors, as appopriate.
                    """
                    qs = self._original_get_ancestors(
                        ascending=ascending, include_self=include_self)
                    if not ignore_publish_status:
                        return type(self).objects.filter(
                            pk__in=qs.values_list('pk', flat=True),
                            publishing_is_draft=self.publishing_is_draft)
                    return qs
