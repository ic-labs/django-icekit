try:
    import json
except ImportError:
    from django.utils import simplejson as json

from django import http
from django.conf.urls import patterns, url
from django.contrib import admin
from django.contrib.contenttypes.models import ContentType
from django.core.exceptions import FieldDoesNotExist

from icekit.admin_tools.utils import admin_link


class RawIdPreviewAdminMixin(admin.ModelAdmin):
    """
    Dynamically display preview rendering of FK/M2M fields in admin forms,
    which is most useful for fields flagged as `raw_id_fields`. Relationship
    fields with single or multiple ID values are supported.

    To render a preview for related FK/M2M target widgets, extend your admin
    from this class and set the `preview_fields` attribute to the appropriate
    field names.

    By default a <UL> list of `unicode` target object values is rendered.

    The rendered HTML is the result of calling `admin.preview(obj, request)` on
    the related admin::

        def preview(self, obj, request):
            return u'<img src="{0}" alt="{1}"><p>{1}</p>'.format(
                obj.url, unicode(obj))


    or `obj.preview(request)` on the linked object(s)::

        def preview(self, request):
            return u'<img src="{0}" alt="{1}"><p>{1}</p>'.format(
                self.url, unicode(self))


    To override the preview, implement a `preview_<fieldname>` method that
    returns the HTML to represent a single target object, like so::

        def preview_image(self, obj, request):
            return u'<img src="{0}" alt="{1}"><p>{1}</p>'.format(
                obj.image.url, unicode(obj))

    For InlineAdmins, call the function preview_<modelname>_<fieldname>.
    """

    # Override this attribute with field names for which to show preview
    preview_fields = []

    class Media:
        js = ('admin/js/preview-field-admin.js',)
        css = {
            'all': ('admin/css/preview-field-admin.css',),
        }

    def render_field_default(self, obj, request):
        """
        Default rendering for fields without `obj.preview()` or a custom
        `preview_<fieldname>`.
        """
        return unicode(obj)

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

    def render_field_previews(self, id_and_obj_list, admin, request, field_name):
        """
        Override this to customise the preview representation of all objects.
        """
        obj_preview_list = []
        for obj_id, obj in id_and_obj_list:
            try:
                # Handle invalid IDs
                if obj is None:
                    obj_preview = self.render_field_error(
                        obj_id, obj, None, request
                    )
                else:
                    try:
                        obj_preview = admin.preview(obj, request)
                    except AttributeError:
                        try:
                            obj_preview = obj.preview(request)
                        except AttributeError:
                            try:
                                obj_preview = getattr(self, 'preview_{0}'.format(
                                    field_name))(obj, request)
                            except AttributeError:
                                # Fall back to default field rendering
                                obj_preview = self.render_field_default(obj, request)

                obj_link = admin_link(obj, inner_html=obj_preview)
            except Exception as ex:
                obj_link = self.render_field_error(obj_id, obj, ex, request)
            obj_preview_list.append(obj_link)
        li_html_list = [u'<li>{0}</li>'.format(preview)
                        for preview in obj_preview_list]
        if li_html_list:
            return u'<ul>{0}</ul>'.format(u''.join(li_html_list))
        else:
            return ''

    def fetch_field_previews(self, request, pk, field_name, raw_ids):

        # polymorphic models need to resolve to the child model
        try:
            instance = self.get_queryset(request).get(pk=pk)
            if hasattr(instance, "get_real_instance"):
                instance = instance.get_real_instance()
            model = type(instance)
        except ValueError: # pk = "add"
            # if this is a polymorphic add, get the child model
            if request.GET.get('ct_id', None):
                model = ContentType.objects.get(id=request.GET['ct_id']).model_class()
            else:
                model = self.model

        # Get the model admin for the real model to use instead of self when
        # getting inline instances
        model_admin = self
        if model != self.model:
            model_admin = self.admin_site._registry.get(model, self)

        try:
            ids = map(int, raw_ids.split(','))
        except ValueError:
            if raw_ids == '':
                ids = []
            else:
                raise http.Http404

        # in inlines, the field name is "inlinemodel_field-num-fieldname"
        if "-" in field_name:
            inline_model_name, num, sub_field_name = field_name.split("-")

            target_model_admin = None

            if hasattr(model, inline_model_name):
                # the inline model is an attribute of the parent model
                # (e.g. 'FOO_set' or similar).
                target_model_admin = self.admin_site._registry.get(
                    # deep breath...
                    getattr(model, inline_model_name).
                        related.related_model.
                        _meta.get_field(sub_field_name).rel.to
                )
            else:
                # look in (injected) inlines for the inline model
                inlines = model_admin.get_inline_instances(request)
                for inline in inlines:
                    content_type = ContentType.objects.get_for_model(inline.model)
                    if inline_model_name == content_type.model:
                        # this is our guy
                        try:
                            target_model_admin = self.admin_site._registry.get(
                                inline.model._meta.get_field(sub_field_name).rel.to
                            )
                        except (AttributeError, FieldDoesNotExist):
                            # For lookups on non-existent fields or fields that
                            # aren't relation fields, 404 instead of 500
                            raise http.Http404
                        break

            # make a simplified field name for preview_FOO override
            field_name = "%s_%s" % (inline_model_name, sub_field_name)

            if target_model_admin is None:
                raise http.Http404
        else: # not an inline, just a field
            target_model_admin = self.admin_site._registry.get(
                model._meta.get_field(field_name).rel.to
            )

        if (
            target_model_admin and
            target_model_admin.has_change_permission(request)
        ):
            qs = target_model_admin.get_queryset(request).filter(id__in=ids)

            # Keep ordering of IDs provided
            obj_dict = dict([(obj.pk, obj) for obj in qs.all()])
            ids_and_objs_list = map(lambda id: (id, obj_dict.get(id)), ids)
            # Generate preview HTML list
            response_data = self.render_field_previews(
                ids_and_objs_list, admin=target_model_admin, request=request, field_name=field_name)
        else:
            response_data = ''  # graceful-ish.
        return http.HttpResponse(
            json.dumps(response_data), content_type='application/json')


    def get_urls(self):
        urlpatterns = patterns(
            '',
            url(
                r'^(?P<pk>.+)/preview-field/(?P<field_name>[\w\d-]+)/(?P<raw_ids>[\d,]+)/$',
                self.admin_site.admin_view(self.fetch_field_previews))
        )

        return urlpatterns + super(RawIdPreviewAdminMixin, self).get_urls()


# TODO: Holdover from CookedIdAdmin. Not sure whether this is still needed.

# class MediaWithInlineJS(Media):
#     """
#     Used internally by CookedSingletonFix, a helper class that adds inline JS
#     functionality to django's internal Media objects, which otherwise only
#     support lists of URLs for JS and CSS files.
#
#     Note that the inline JS functionality will be lost if a MediaWithInlineJS
#     object is on the right-hand side of an addition with a normal Media object.
#     """
#
#     def __init__(self, *args, **kwargs):
#         self.inline_js = kwargs.pop('inline_js', '')
#         super(MediaWithInlineJS, self).__init__(*args, **kwargs)
#
#     def render_js(self):
#         return super(MediaWithInlineJS, self).render_js() + [self.inline_js]
#
#     def __add__(self, other):
#         combined = MediaWithInlineJS(inline_js=self.inline_js)
#         for name in MEDIA_TYPES:
#             getattr(combined, 'add_' + name)(getattr(self, '_' + name, None))
#             getattr(combined, 'add_' + name)(getattr(other, '_' + name, None))
#         return combined
#
#
# class CookedSingletonFix(object):
#     """
#     A ModelAdmin mixin for singleton objects (provided by the django-singleton
#     library) that use cooked IDs. Place before SingletonAdmin and CookiedIdAdmin
#     in the inheritance list.
#
#     Cooked IDs will not work on singleton models without this fix due to the
#     way the JS constructs the URL for the "cook" requests. Singleton models
#     don't have a PK in their admin URLs, which is the root of the issue.
#
#     This fix adds inline JS via the ModelAdmin.Media mechanic to set the
#     "window.cooked_id_url_base" JS variable, so that working URLs can be
#     constructed. The fix is generic enough to work with non-singleton models
#     as well, but is provided as an explicit mix-in due to its reliance on
#     the addition order of Media objects in the ModelAdmin internals, which is
#     subject to sudden and confusing breakage.
#     """
#
#     @property
#     def media(self):
#         # Because singleton models don't have a PK section in their URL,
#         # using './' doesn't work, but instead of faking a PK, the add
#         # URL should be a cleaner approach
#         base_url = reverse('admin:%s_%s_add' % (
#             self.model._meta.app_label, self.model._meta.module_name)
#                            )
#         extra_script = '<script type="text/javascript">' \
#                        'window.cooked_id_url_base="%s";</script>' % base_url
#         return MediaWithInlineJS(inline_js=extra_script) \
#                + super(CookedSingletonFix, self).media
