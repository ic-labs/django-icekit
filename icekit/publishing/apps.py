from django.apps import AppConfig, apps
from django.core.exceptions import MultipleObjectsReturned
from django.utils.translation import get_language

from fluent_pages import appsettings
from fluent_pages.models import UrlNode
from fluent_pages.models.managers import UrlNodeQuerySet

from polymorphic.polymorphic_model import PolymorphicModel

from mptt.models import MPTTModel

from . import monkey_patches
from .managers import PublishingQuerySet, PublishingPolymorphicManager, \
    PublishingUrlNodeManager, UrlNodeQuerySetWithPublishingFeatures, \
    DraftItemBoobyTrap, _queryset_iterator
from .models import PublishingModel
from .middleware import is_draft_request_context, \
    is_publishing_middleware_active


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
        # Ensure everything below is only ever run once
        # TODO This check is necessary for Django 1.7 events tests, why?
        if getattr(AppConfig, 'has_run_ready', False):
            return
        AppConfig.has_run_ready = True

        monkey_patches.APPLY_patch_urlnodeadminform_clean_for_publishable_items()
        monkey_patches.APPLY_patch_django_17_collector_collect()
        monkey_patches.APPLY_patch_django_18_get_candidate_relations_to_delete()

        # Monkey-patch `UrlNodeQuerySet.published` to avoid filtering out draft
        # items when we are in a draft request context when the special-case
        # `for_user` parameter is supplied. The original only avoids this
        # filtering for logged-in staff users, but we need to avoid it for
        # other cases like when a specially "signed" draft URL is shared.
        @monkey_patch_override_method(UrlNodeQuerySet)
        def published(self, for_user=None):
            if for_user is not None and is_draft_request_context():
                return self._single_site()
            else:
                return self._original_published(for_user=for_user)

        @monkey_patch_override_method(UrlNodeQuerySet)
        def iterator(self):
            return _queryset_iterator(self)

        # Monkey-patch `UrlNodeQuerySet.get_for_path` to add filtering by
        # publishing status.
        @monkey_patch_override_method(UrlNodeQuerySet)
        def get_for_path(self, path, language_code=None):
            """
            Return the UrlNode for the given path.
            The path is expected to start with an initial slash.

            Raises UrlNode.DoesNotExist when the item is not found.
            """
            if language_code is None:
                language_code = self._language or get_language()

            # Don't normalize slashes, expect the URLs to be sane.
            qs = self._single_site().filter(
                translations___cached_url=path,
                translations__language_code=language_code,
            )

            obj = _filter_candidates_by_published_status(qs, self.model, path)

            # Explicitly set language to the state the object was fetched in.
            obj.set_current_language(language_code)
            return obj

        # Monkey-patch `UrlNodeQuerySet.best_match_for_path` to add filtering
        # by publishing status.
        @monkey_patch_override_method(UrlNodeQuerySet)
        def best_match_for_path(self, path, language_code=None):
            if language_code is None:
                language_code = self._language or get_language()

            # Based on FeinCMS:
            paths = self._split_path_levels(path)

            qs = self._single_site() \
                    .filter(translations___cached_url__in=paths,
                            translations__language_code=language_code) \
                    .extra(select={'_url_length': 'LENGTH(_cached_url)'}) \
                    .order_by('-level', '-_url_length')

            obj = _filter_candidates_by_published_status(qs, self.model, path)

            obj.set_current_language(language_code)
            return obj

        def _filter_candidates_by_published_status(candidates, model, path):
            # Filter candidate results by published status, using
            # instance attributes instead of queryset filtering to
            # handle unpublishable and ICEKit publishing-enabled items.
            objs = set()  # Set to avoid duplicates
            if is_draft_request_context():
                for candidate in candidates:
                    # Keep candidates that are publishable draft copies, or
                    # that are not publishable (i.e. they don't have the
                    # `is_draft` attribute at all)
                    if getattr(candidate, 'is_draft', True):
                        objs.add(candidate)
                    # Also keep candidates where we have the published copy and
                    # can exchange to get the draft copy
                    elif hasattr(candidate, 'get_draft'):
                        objs.add(candidate.get_draft())
            else:
                for candidate in candidates:
                    # Keep candidates that are published, or that are not
                    # publishable (i.e. they don't have the `is_published`
                    # attribute)
                    if getattr(candidate, 'is_published', True):
                        # Skip candidates that are not within any publication
                        # date restrictions
                        if (hasattr(candidate, 'is_within_publication_dates')
                            and not candidate.is_within_publication_dates()
                        ):
                            pass
                        else:
                            objs.add(candidate)

            if not objs:
                raise model.DoesNotExist(
                    u"No published {0} found for the path '{1}'"
                    .format(model.__name__, path))

            if len(objs) > 1:
                # TODO May need special handling for SFMOMA StoryPage slugs
                # which can overlap. E.g. return the first one with no
                # category, or the last one if they all have categories.

                raise model.MultipleObjectsReturned(
                    u"Multiple published {0} found for the path '{1}'"
                    .format(model.__name__, path))

            return objs.pop()

        # Monkey-patch method overrides for classes where we must do so to
        # avoid our custom versions from getting clobbered by versions higher
        # up the inheritance hierarchy.
        for model in apps.get_models():

            # Monkey-patch the queryset class used by any model descriptors
            # that represent relationships to publishable items, including
            # our own and `UrlNode`s notions of publishing, so that we can
            # exchange draft items for their corresponding published copies
            # when `published()` is invoked on these relationships.
            try:
                # Django 1.8+
                field_names = [f.name for f in model._meta.get_fields()]
            except AttributeError:
                # Django < 1.8
                field_names = model._meta.get_all_field_names()
            for field_name in field_names:
                try:
                    descriptor = getattr(model, field_name)
                except AttributeError:
                    continue
                # We are only interested in descriptors for related item
                # relationships, which we recognise by the presence of
                # `related_manager_cls`.
                if not hasattr(descriptor, 'related_manager_cls'):
                    continue
                manager_cls = descriptor.related_manager_cls
                # Different item relationships keep the queryset class we need
                # to patch in different places: grab the class and remember the
                # attribute name wherever that class is.
                try:
                    qs_class = manager_cls.queryset_class
                    qs_class_attr = 'queryset_class'
                except AttributeError:
                    qs_class = manager_cls._queryset_class
                    qs_class_attr = '_queryset_class'

                # If queryset is a descendent of our own `PublishingQuerySet`
                # we only need to enable the exchange mechanism so it will
                # happen by default
                if issubclass(qs_class, PublishingQuerySet):
                    #print("Set `exchange_on_published` in queryset class %s.%s"
                    #      % (model, field_name))
                    qs_class.exchange_on_published = True
                # If the queryset is not based on `PublishingQuerySet` but is
                # a `UrlNodeQuerySet` we replace that QS class with our own
                # customised version that overrides the `published()` method.
                elif issubclass(qs_class, UrlNodeQuerySet):
                    #print("Override of UrlNode queryset class for %s.%s"
                    #      % (model, field_name))
                    setattr(manager_cls, qs_class_attr,
                            UrlNodeQuerySetWithPublishingFeatures)
                    # Override published method on manager as well, so our
                    # queryset's implementation of `published()` is used
                    manager_cls.published = \
                        lambda self, **kwargs: self.all().published(**kwargs)

            # Skip any models that don't have publishing features
            if not issubclass(model, PublishingModel):
                continue

            if issubclass(model, PolymorphicModel) \
                    and not issubclass(model, UrlNode):

                PublishingPolymorphicManager().contribute_to_class(
                    model, 'objects')
                PublishingPolymorphicManager().contribute_to_class(
                    model, '_default_manager')

            if issubclass(model, UrlNode):

                PublishingUrlNodeManager().contribute_to_class(
                    model, 'objects')
                PublishingUrlNodeManager().contribute_to_class(
                    model, '_default_manager')

                @monkey_patch_override_method(model)
                def _make_slug_unique(self, translation):
                    """
                    Custom make slug unique checked.
                    :param self: The object to which the slug is or will be
                    associated.
                    :param translation: The particular translation of the slug.
                    :return: None
                    """
                    # Short-circuit processing of newly-published items that do
                    # not yet have a relationship to the corresponding draft.
                    # This avoids triggering `UrlNode._update_descendant_urls`
                    # when it will break because we are saving a partially-
                    # complete published item.
                    if self.is_published:
                        try:
                            self.publishing_draft
                        except type(self).publishing_draft.RelatedObjectDoesNotExist:
                            return

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
