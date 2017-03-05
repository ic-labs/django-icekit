from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.models import PlaceholderData

from icekit.workflow.admin import WorkflowMixinAdmin, \
    WorkflowStateTabularInline

import logging

from icekit.utils.attributes import resolve

from django.utils.translation import ugettext_lazy as _
from django import http
from django.conf import settings
from django.conf.urls import patterns, url
from django.contrib import admin
from django.core.exceptions import ImproperlyConfigured
try:
    import json
except ImportError:
    from django.utils import simplejson as json

logger = logging.getLogger(__name__)


class PreviewFieldAdminMixin(admin.ModelAdmin):
    """
    Dynamically display preview rendering of FK/M2M fields in admin forms,
    which is most useful for fields flagged as `raw_id_fields`. Relationship
    fields with single or multiple ID values are supported.

    To render a preview for related FK/M2M target widgets, extend your admin
    from this class and set the `preview_fields` attribute to the appropriate
    field names.

    By default a <UL> list of `unicode` target object values is rendered.

    To override the preview, implement a `preview_<fieldname>` method that
    returns the HTML to represent a single target object, like so:

        def preview_image(self, obj, request):
            return u'<img src="{0}" alt="{1}"><p>{1}</p>'.format(
                obj.image.url, unicode(obj))
    """

    # Override this attribute with field names for which to show preview
    preview_fields = []

    class Media:
        # TODO: include these in main/global files
        js = ('admin/js/preview-field-admin.js',)
        css = {
            'all': ('admin/css/preview-field-admin.css',),
        }

    def render_field_default(self, obj, request):
        """
        Default rendering for fields without a custom `field_<fieldname>`
        """
        return u'<p>{0}</p>'.format(unicode(obj))

    def render_field_error(self, obj_id, obj, exception, request):
        """
        Default rendering for items in field where the the usual rendering
        method raised an exception.
        """
        if obj is None:
            msg = 'No match for ID={0}'.format(obj_id)
        else:
            msg = unicode(exception)
        return u'<p class="error">{0}</p>'.format(msg)

    def render_field_previews(self, id_and_obj_list, request, field_name):
        """
        Override this to customise the preview representation of all objects.
        """
        try:
            preview_fn = getattr(self, 'preview_{0}'.format(field_name))
        except AttributeError:
            # Fall back to default field rendering
            preview_fn = self.render_field_default

        obj_preview_list = []
        for obj_id, obj in id_and_obj_list:
            try:
                # Handle invalid IDs
                if obj is None:
                    obj_preview = self.render_field_error(
                        obj_id, obj, None, request)
                else:
                    obj_preview = preview_fn(obj, request)
            except Exception as ex:
                obj_preview = self.render_field_error(obj_id, obj, ex, request)
            obj_preview_list.append(obj_preview)
        li_html_list = [u'<li>{0}</li>'.format(preview)
                        for preview in obj_preview_list]
        if li_html_list:
            return u'<ul>{0}</ul>'.format(u''.join(li_html_list))
        else:
            return ''

    def fetch_field_previews(self, request, pk, field_name, raw_ids):
        if field_name not in self.preview_fields:
            raise http.Http404
        try:
            ids = map(int, raw_ids.split(','))
        except ValueError:
            if raw_ids == '':
                ids = []
            else:
                raise http.Http404
        target_model_admin = self.admin_site._registry.get(
            self.model._meta.get_field(field_name).rel.to)
        if (
                target_model_admin and
                target_model_admin.has_change_permission(request)
        ):
            try:
                # Django >= 1.8
                qs = target_model_admin.get_queryset(request).filter(id__in=ids)
            except AttributeError:
                qs = target_model_admin.queryset(request).filter(id__in=ids)
            # Keep ordering of IDs provided
            obj_dict = dict([(obj.pk, obj) for obj in qs.all()])
            ids_and_objs_list = map(lambda id: (id, obj_dict.get(id)), ids)
            # Generate preview HTML list
            response_data = self.render_field_previews(
                ids_and_objs_list, request=request, field_name=field_name)
        else:
            response_data = ''  # graceful-ish.
        return http.HttpResponse(
            json.dumps(response_data), content_type='application/json')

    def get_urls(self):
        urlpatterns = patterns(
            '',
            url(r'^(?P<pk>.+)/preview-field/(?P<field_name>\w+)/(?P<raw_ids>[\d,]+)/$',
                self.admin_site.admin_view(self.fetch_field_previews))
        )
        # TODO inlines, see CookedIdAdmin
        return urlpatterns + super(PreviewFieldAdminMixin, self).get_urls()

    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        formfield = super(PreviewFieldAdminMixin, self) \
            .formfield_for_foreignkey(db_field, request=request, **kwargs)
        if db_field.name in self.preview_fields:
            if self.assert_target_admin_in_site_registry(db_field):
                formfield.widget.attrs['data-is-preview-field'] = 'true'
        return formfield

    def formfield_for_manytomany(self, db_field, request=None, **kwargs):
        formfield = super(PreviewFieldAdminMixin, self) \
            .formfield_for_manytomany(db_field, request=request, **kwargs)
        if db_field.name in self.preview_fields:
            if self.assert_target_admin_in_site_registry(db_field):
                formfield.widget.attrs['data-is-preview-field'] = 'true'
        return formfield

    def assert_target_admin_in_site_registry(self, db_field):
        if db_field.rel.to in self.admin_site._registry:
            return True
        else:
            if settings.DEBUG:
                raise ImproperlyConfigured(
                    "%s.preview_fields contains '%r', but %r "
                    "is not registed in the same admin site." % (
                        self.__class__.__name__,
                        db_field.name,
                        db_field.rel.to,
                    )
                )
            else:
                pass  # fail silently


class FluentLayoutsMixin(PlaceholderEditorAdmin, PreviewFieldAdminMixin):
    """
    Mixin class for models that have a ``layout`` field and fluent content.
    """

    change_form_template = 'icekit/admin/fluent_layouts_change_form.html'

    class Media:
        js = ('icekit/admin/js/fluent_layouts.js', )

    def formfield_for_foreignkey(self, db_field, *args, **kwargs):
        """
        Update queryset for ``layout`` field.
        """
        formfield = super(FluentLayoutsMixin, self).formfield_for_foreignkey(
            db_field, *args, **kwargs)
        if db_field.name == 'layout':
            formfield.queryset = formfield.queryset.for_model(self.model)
        return formfield

    def get_placeholder_data(self, request, obj):
        """
        Get placeholder data from layout.
        """
        if not obj or not obj.layout:
            data = [PlaceholderData(slot='main', role='m', title='Main')]
        else:
            data = obj.layout.get_placeholder_data()
        return data


class HeroMixinAdmin(admin.ModelAdmin):
    raw_id_fields = ('hero_image',)

    # Alas, we cannot use 'fieldsets' as it causes a recursionerror on
    # (polymorphic?) admins that use base_fieldsets.
    FIELDSETS = (
        ('Hero section', {
            'fields': (
                'hero_image',
            )
        }),
    )


class ListableMixinAdmin(admin.ModelAdmin):
    FIELDSETS = (
        ('Advanced listing options', {
            'classes': ('collapse',),
            'fields': (
                'list_image',
                'boosted_search_terms',
            )
        }),
    )


# This import must go here to avoid class loading errors
from icekit.publishing.admin import ICEKitFluentPagesParentAdminMixin


# WARNING: Beware of very closely named classes here
class ICEkitFluentPagesParentAdmin(
    ICEKitFluentPagesParentAdminMixin,
    WorkflowMixinAdmin,
    PreviewFieldAdminMixin,
):
    """
    A base for Fluent Pages parent admins that will include ICEkit features:

     - publishing
     - workflow
    """
    # Go through contortions here to make sure the 'actions_column' is last
    list_display = [
        display_column for display_column in (
            ICEKitFluentPagesParentAdminMixin.list_display +
            WorkflowMixinAdmin.list_display)
        if display_column != 'actions_column'] + ['actions_column']
    list_filter = ICEKitFluentPagesParentAdminMixin.list_filter + \
        WorkflowMixinAdmin.list_filter
    inlines = [WorkflowStateTabularInline]


# import has to happen here to avoid circular import errors
from icekit.publishing.admin import PublishingAdmin, \
    PublishableFluentContentsAdmin


class ICEkitContentsAdmin(
    PublishingAdmin,
    WorkflowMixinAdmin,
    PreviewFieldAdminMixin,
):
    """
    A base for generic admins that will include ICEkit features:

     - publishing
     - workflow
    """
    list_display = PublishingAdmin.list_display + \
        WorkflowMixinAdmin.list_display
    list_filter = PublishingAdmin.list_filter + \
        WorkflowMixinAdmin.list_filter
    inlines = [WorkflowStateTabularInline]


class ICEkitFluentContentsAdmin(
    PublishableFluentContentsAdmin,
    WorkflowMixinAdmin,
    PreviewFieldAdminMixin,
):
    """
    A base for Fluent Contents admins that will include ICEkit features:

     - publishing
     - workflow
    """
    list_display = ICEkitContentsAdmin.list_display
    list_filter = ICEkitContentsAdmin.list_filter
    inlines = ICEkitContentsAdmin.inlines


class ThumbnailAdminMixin(object):
    """
    Shortcut for displaying a thumbnail in a changelist (or inline).

    Requires easy-thumbnails.

    Specify ImageField name in `thumbnail_field`, and optionally
    override `thumbnail_options` for customisation such as sizing,
    cropping, etc. If `thumbnail_show_exceptions` is truthy, exception
    messages are returned in place of a thumbnail on failure.

    Plays nicely with list_display_links if you want a click-able
    thumbnail.

    Add 'thumbnail' to `list_display` or `readonly_fields`, etc to
    display.
    """

    thumbnail_field = None # an attribute or callable on the object
    try:
        thumbnail_options = settings.THUMBNAIL_ALIASES['']['admin']
    except (KeyError, AttributeError):
        thumbnail_options = {'size': (150, 150),}
    thumbnail_show_exceptions = False

    def get_thumbnail_source(self, obj):
        """
        Obtains the source image field for the thumbnail.

        :param obj: An object with a thumbnail_field defined.
        :return: Image field for thumbnail or None if not found.
        """
        if hasattr(self, 'thumbnail_field') and self.thumbnail_field:
            return resolve(obj, self.thumbnail_field)

        # try get_list_image, from ListableMixin
        if hasattr(obj, 'get_list_image'):
            return resolve(obj, "get_list_image")

        logger.warning('ThumbnailAdminMixin.thumbnail_field unspecified')
        return None

    def thumbnail(self, obj):
        """
        Generate the HTML to display for the image.

        :param obj: An object with a thumbnail_field defined.
        :return: HTML for image display.
        """
        source = self.get_thumbnail_source(obj)
        if source:
            try:
                from easy_thumbnails.files import get_thumbnailer
            except ImportError:
                logger.warning(
                    _(
                        '`easy_thumbnails` is not installed and required for '
                        'icekit.utils.admin.mixins.ThumbnailAdminMixin'
                    )
                )
                return ''
            try:
                thumbnailer = get_thumbnailer(source)
                thumbnail = thumbnailer.get_thumbnail(self.thumbnail_options)
                return '<img class="thumbnail" src="{0}" />'.format(
                    thumbnail.url)
            except Exception as ex:
                logger.warning(
                    _(u'`easy_thumbnails` failed to generate a thumbnail image'
                      u' for {0}'.format(source)))
                if self.thumbnail_show_exceptions:
                    return 'Thumbnail exception: {0}'.format(ex)
        return ''
    thumbnail.allow_tags = True
