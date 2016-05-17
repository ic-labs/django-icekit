from django.apps import AppConfig, apps
from django.core.exceptions import MultipleObjectsReturned
from django.db.models.query_utils import Q
from django.utils.translation import get_language
from django.utils.timezone import now

from fluent_pages import appsettings
from fluent_pages.models import UrlNode
from fluent_pages.models.managers import UrlNodeQuerySet

from mptt.models import MPTTModel

from .managers import PublishingUrlNodeManager, _exchange_for_published
from .models import PublishingModel
from .middleware import is_draft_request_context


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

        # Monkey-patch `UrlNodeQuerySet.published` to add filtering by
        # publishing status and exchange of draft items to published ones.
        # This is necessary to make publishable items available via
        # relationship querysets where the relationship is generally to draft
        # items but we want to get the correponding published copies.
        @monkey_patch_override_method(UrlNodeQuerySet)
        def published(self, for_user=None):
            if for_user is not None and for_user.is_staff:
                return self._single_site()

            qs = self._single_site() \
                .filter(
                    Q(publication_date__isnull=True) |
                    Q(publication_date__lt=now())
                ).filter(
                    Q(publication_end_date__isnull=True) |
                    Q(publication_end_date__gte=now())
                )

            # Include publishable items that are published themselves, or are
            # draft copies with a published copy.
            items_to_include_pks = [
                i.pk for i in qs
                if i.is_published or getattr(i, 'has_been_published', False)
            ]
            qs = qs.filter(pk__in=items_to_include_pks)

            return _exchange_for_published(qs)

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
            objs = self._single_site().filter(
                translations___cached_url=path,
                translations__language_code=language_code,
            )

            # Filter candidate results by published status, using
            # instance attributes instead of queryset filtering to
            # handle unpublishable and ICEKit publishing-enabled items.
            if is_draft_request_context():
                objs = [obj for obj in objs
                        if getattr(obj, 'is_draft', True)]
            else:
                objs = [obj for obj in objs
                        if getattr(obj, 'is_published', True) and
                        (not hasattr(obj, 'is_within_publication_dates') or
                         obj.is_within_publication_dates())]

            if not objs:
                raise self.model.DoesNotExist(
                    u"No published {0} found for the path '{1}'"
                    .format(self.model.__name__, path))

            if len(objs) > 1:
                # TODO May need special handling for SFMOMA StoryPage slugs
                # which can overlap. E.g. return the first one with no
                # category, or the last one if they all have categories.

                raise self.model.MultipleObjectsReturned(
                    u"Multiple published {0} found for the path '{1}'"
                    .format(self.model.__name__, path))

            obj = objs[0]
            # Explicitly set language to the state the object was fetched in.
            obj.set_current_language(language_code)
            return obj

        # Monkey-patch method overrides for classes where we must do so to
        # avoid our custom versions from getting clobbered by versions higher
        # up the inheritance hierarchy.
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
