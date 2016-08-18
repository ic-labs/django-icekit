import json

import django
from django import forms
from django.contrib import messages
from django.contrib.admin import ModelAdmin, SimpleListFilter
from django.conf import settings
from django.conf.urls import patterns, url
from django.core.exceptions import PermissionDenied
from django.core.urlresolvers import reverse, NoReverseMatch
from django.db.models import F
from django.http import Http404, HttpResponseRedirect, HttpResponse
from django.utils.encoding import force_text
from django.utils.html import escape
from django.utils.translation import ugettext_lazy as _
from django.template import loader, Context

from fluent_pages.models.db import UrlNode
from fluent_pages.adminui.pageadmin import DefaultPageChildAdmin, \
    _select_template_name
from fluent_pages.adminui.urlnodeparentadmin import UrlNodeParentAdmin
from .models import PublishingModel


def make_published(modeladmin, request, queryset):
    for row in queryset.all():
        row.publish()
make_published.short_description = _('Publish')


def make_unpublished(modeladmin, request, queryset):
    for row in queryset.all():
        row.unpublish()
make_unpublished.short_description = _('Unpublish')


def http_json_response(data):
    return HttpResponse(json.dumps(data), content_type='application/json')


class PublishingPublishedFilter(SimpleListFilter):
    title = _('Published')
    parameter_name = 'published'

    def lookups(self, request, model_admin):
        return (
            ('1', _('Yes')),
            ('0', _('No'))
        )

    def queryset(self, request, queryset):
        try:
            value = int(self.value())
        except TypeError:
            return queryset

        isnull = not value
        return queryset.filter(publishing_linked__isnull=isnull)


class PublishingStatusFilter(SimpleListFilter):
    """
    Filter events by published status, which will be one of:

        - unpublished: item is not published; it has no published copy
            available via the ``publishing_linked`` relationship.

        - published: item is published but may or may not be up-to-date;
            it has a published copy available via the ``publishing_linked``
            relationship.

        - out_of_date: item is published but the published copy is older
            than the latest draft; the draft's ``publishing_modified_at`` is
            later than this timestamp in the published copy.

        - up_to_date: item is published and the published copy is based
            on the latest draft; the draft's ``publishing_modified_at`` is
            earlier or equal to this timestamp in the published copy.

    Be aware that this queryset filtering happens after the admin queryset is
    already filtered to include only draft copies of published items.
    """
    title = _('publishing status')
    parameter_name = 'publishing_status'

    UNPUBLISHED = 'unpublished'
    PUBLISHED = 'published'
    OUT_OF_DATE = 'out_of_date'
    UP_TO_DATE = 'up_to_date'

    def lookups(self, request, model_admin):
        lookups = (
            (self.UNPUBLISHED, _('Unpublished')),
            (self.PUBLISHED, _('Published')),
            (self.OUT_OF_DATE, _('Published & Out-of-date')),
            (self.UP_TO_DATE, _('Published & Up-to-date')),
        )
        return lookups

    def queryset(self, request, queryset):
        if self.value() == 'unpublished':
            return queryset.filter(publishing_linked__isnull=True)
        elif self.value() == 'published':
            return queryset.filter(publishing_linked__isnull=False)
        elif self.value() == 'out_of_date':
            return queryset.filter(
                publishing_modified_at__gt=F(
                    'publishing_linked__publishing_modified_at'))
        elif self.value() == 'up_to_date':
            return queryset.filter(
                publishing_modified_at__lte=F(
                    'publishing_linked__publishing_modified_at'))


class PublishingAdminForm(forms.ModelForm):
    """
    The admin form that provides functionality for `PublishingAdmin`.

    NOTE: Be extremely careful changing the ordering, extending or
    removing classes this class extends. This is because there is a
    super call to `UrlNodeAdminForm` which skips the validation steps
    on `UrlNodeAdminForm`.
    """

    def __init__(self, *args, **kwargs):
        # Add request to self if available. This is to provide site support
        # with `get_current_site` calls.
        self.request = kwargs.pop('request', None)
        super(PublishingAdminForm, self).__init__(*args, **kwargs)

    def clean(self):
        """
        Additional clean data checks for path and keys.

        These are not cleaned in their respective methods e.g.
        `clean_slug` as they depend upon other field data.

        :return: Cleaned data.
        """
        data = super(PublishingAdminForm, self).clean()
        cleaned_data = self.cleaned_data
        instance = self.instance

        # work out which fields are unique_together
        unique_fields_set = instance.get_unique_together()

        if not unique_fields_set:
            return data

        for unique_fields in unique_fields_set:
            unique_filter = {}
            for unique_field in unique_fields:
                field = instance.get_field(unique_field)

                # Get value from the form or the model
                if field.editable:
                    unique_filter[unique_field] = cleaned_data[unique_field]
                else:
                    unique_filter[unique_field] = \
                        getattr(instance, unique_field)

            # try to find if any models already exist in the db; I find all
            # models and then exclude those matching the current model.
            existing_instances = type(instance).objects \
                                               .filter(**unique_filter) \
                                               .exclude(pk=instance.pk)

            if instance.publishing_linked:
                existing_instances = existing_instances.exclude(
                    pk=instance.publishing_linked.pk)

            if existing_instances:
                for unique_field in unique_fields:
                    self._errors[unique_field] = self.error_class(
                        [_('This value must be unique.')])

        return data


class _PublishingHelpersMixin(object):
    """
    Publishing implementation used for the admin of both normal publishable
    models, and for the "parent" page admins used by Fluent which needs to
    cope with models that may or may not implement our publishing features.
    """

    def __init__(self, *args, **kwargs):
        super(_PublishingHelpersMixin, self).__init__(*args, **kwargs)
        self.request = None

    def is_admin_for_publishable_model(self):
        return hasattr(self, 'model') \
                and issubclass(self.model, PublishingModel)

    # TODO Cache this
    def get_url_name_prefix(self, model=None):
        if not model:
            model = self.model
        return '%(app_label)s_%(module_name)s_' % {
            'app_label': model._meta.app_label,
            'module_name': (model._meta.model_name
                            if django.VERSION >= (1, 7)
                            else model._meta.module_name),
        }

    # TODO Cache this
    def publish_reverse(self, model=None):
        return '%s:%spublish' % (
            self.admin_site.name, self.get_url_name_prefix(model))

    # TODO Cache this
    def unpublish_reverse(self, model=None):
        return '%s:%sunpublish' % (
            self.admin_site.name, self.get_url_name_prefix(model))

    def has_publish_permission(self, request, obj=None):
        """
        Determines if the user has permissions to publish.

        :param request: Django request object.
        :param obj: The object to determine if the user has
        permissions to publish.
        :return: Boolean.
        """
        user_obj = request.user
        if user_obj.is_superuser:
            return True
        if not user_obj.is_active:
            return False
        return user_obj.has_perm('%s.can_publish' % self.opts.app_label)

    def publishing_column(self, obj):
        """
        Render publishing-related status icons and view links for display in
        the admin.
        """
        # TODO Hack to convert polymorphic objects to real instances
        if hasattr(obj, 'get_real_instance'):
            obj = obj.get_real_instance()

        try:
            published_obj_url = obj.get_absolute_url()
            draft_obj_url = published_obj_url + '?edit'
        except:
            published_obj_url = draft_obj_url = None

        template_name = 'admin/publishing/_change_list_publishing_column.html'
        t = loader.get_template(template_name)
        c = Context({
            'object': obj,
            'has_publish_permission':
                self.has_publish_permission(self.request, obj),
            'img_path': settings.STATIC_URL + 'admin/img/',
            'published_url': published_obj_url,
            'draft_url': draft_obj_url,
        })
        try:
            if isinstance(obj, PublishingModel):
                c['publish_url'] = reverse(
                    self.publish_reverse(type(obj)), args=(obj.pk, ))
                c['unpublish_url'] = reverse(
                    self.unpublish_reverse(type(obj)), args=(obj.pk, ))
        except NoReverseMatch:
            pass
        return t.render(c)
    publishing_column.allow_tags = True
    publishing_column.short_description = _('Published')


class PublishingAdmin(ModelAdmin, _PublishingHelpersMixin):
    form = PublishingAdminForm
    # publish or unpublish actions sometime makes the plugins disappear from
    # page so we disable it for now, until we can investigate it further.
    # actions = (make_published, make_unpublished, )
    list_display = ('publishing_object_title', 'publishing_column',)
    list_filter = (PublishingStatusFilter, PublishingPublishedFilter)

    actions = ['publish', 'unpublish']

    class Media:
        js = (
            'publishing/publishing.js',
        )
        css = {
            'all': ('publishing/publishing.css', ),
        }

    def __init__(self, model, admin_site):
        super(PublishingAdmin, self).__init__(model, admin_site)

        # Reverse URL strings used in multiple places..
        self.revert_reverse = '%s:%srevert' % (
            self.admin_site.name,
            self.get_url_name_prefix(model), )
        self.changelist_reverse = '%s:%schangelist' % (
            self.admin_site.name,
            self.get_url_name_prefix(model), )

        # Some admins are missing a `change_form_template` such as
        # PolymorphicParentModelAdmin
        if self.change_form_template:
            self.non_publishing_change_form_template = \
                self.find_first_available_template(self.change_form_template)

    def find_first_available_template(self, template_name_list):
        """
        Given a list of template names, find the first one that actually exists
        and is available.
        """
        if isinstance(template_name_list, basestring):
            return template_name_list
        else:
            # Take advantage of fluent_pages' internal implementation
            return _select_template_name(template_name_list)

    def publishing_object_title(self, obj):
        return u'%s' % obj
    publishing_object_title.short_description = 'Title'

    def publishing_admin_filter_for_drafts(self, qs):
        """ Remove published items from the given QS """
        return qs.filter(publishing_is_draft=True)

    def get_queryset(self, request):
        """
        The queryset to use for the administration list page.

        :param request: Django request object.
        :return: QuerySet.
        """
        # TODO Can we remove this hack?
        self.request = request

        # Obtain the full queryset defined on the registered model.
        qs = self.model.objects

        # Determine if a specific language should be used and filter by it if
        # required.
        try:
            qs_language = self.get_queryset_language(request)
            if qs_language:
                qs = qs.language(qs_language)
        except AttributeError:  # this isn't translatable
            pass

        # Use all draft object versions in the admin.
        qs = self.publishing_admin_filter_for_drafts(qs)

        # If ordering has been specified in the admin definition order by it.
        ordering = getattr(self, 'ordering', None) or ()
        if ordering:
            qs = qs.order_by(*ordering)

        # Return the filtered queryset.
        return qs

    queryset = get_queryset

    def get_urls(self):
        urls = super(PublishingAdmin, self).get_urls()

        if not self.is_admin_for_publishable_model():
            return urls

        publish_name = '%spublish' % (self.get_url_name_prefix(), )
        unpublish_name = '%sunpublish' % (self.get_url_name_prefix(), )
        revert_name = '%srevert' % (self.get_url_name_prefix(), )

        publish_urls = patterns(
            '',
            url(r'^(?P<object_id>\d+)/publish/$',
                self.publish_view, name=publish_name),
            url(r'^(?P<object_id>\d+)/unpublish/$',
                self.unpublish_view, name=unpublish_name),
            url(r'^(?P<object_id>\d+)/revert/$',
                self.revert_view, name=revert_name),
        )

        return publish_urls + urls

    def get_model_object(self, request, object_id):
        # Enforce DB-level locking of the object with `select_for_update` to
        # avoid data consistency issues caused by multiple simultaneous form
        # submission (e.g. by a user who double-clicks form buttons).
        obj = self.model.objects.select_for_update().get(pk=object_id)

        if not self.has_change_permission(request, obj):
            raise PermissionDenied

        if obj is None:
            raise Http404(
                _('%s object with primary key %s does not exist.') % (
                    force_text(self.model._meta.verbose_name),
                    escape(object_id)
                ))

        if not self.has_change_permission(request) \
                and not self.has_add_permission(request):
            raise PermissionDenied

        return obj

    def revert_view(self, request, object_id):
        obj = self.get_model_object(request, object_id)

        if not self.has_publish_permission(request, obj):
            raise PermissionDenied

        obj.revert_to_public()

        if not request.is_ajax():
            messages.success(
                request, _('Draft has been revert to the public version.'))
            return HttpResponseRedirect(reverse(self.changelist_reverse))

        return http_json_response({'success': True})

    def unpublish_view(self, request, object_id):
        obj = self.get_model_object(request, object_id)

        if not self.has_publish_permission(request, obj):
            raise PermissionDenied

        obj.unpublish()

        if not request.is_ajax():
            messages.success(request, _('Published version has been deleted.'))
            return HttpResponseRedirect(reverse(self.changelist_reverse))

        return http_json_response({'success': True})

    def publish_view(self, request, object_id):
        obj = self.get_model_object(request, object_id)

        if not self.has_publish_permission(request, obj):
            raise PermissionDenied

        obj.publish()

        if not request.is_ajax():
            messages.success(request, _('Draft version has been published.'))
            return HttpResponseRedirect(reverse(self.changelist_reverse))

        return http_json_response({'success': True})

    def render_change_form(self, request, context, add=False, change=False,
                           form_url='', obj=None):
        """
        Provides the context and rendering for the admin change form.

        :param request: Django request object.
        :param context: The context dictionary to be passed to the template.
        :param add: Should the add form be rendered? Boolean input.
        :param change: Should the change for be rendered? Boolean input.
        :param form_url: The URL to use for the form submit action.
        :param obj: An object the render change form is for.
        """
        obj = context.get('original', None)
        if obj:
            if not self.has_publish_permission(request, obj):
                context['has_publish_permission'] = False
            else:
                context['has_publish_permission'] = True

                # If the user has publishing permission and if there are
                # changes which are to be published show the publish button
                # with relevant URL.
                publish_btn = None
                if obj.is_dirty:
                    publish_btn = reverse(
                        self.publish_reverse(type(obj)), args=(obj.pk, ))

                # If the user has publishing permission, a draft object and
                # a published object show the unpublish button with relevant
                # URL.
                unpublish_btn = None
                if obj.is_draft and obj.publishing_linked:
                    unpublish_btn = reverse(
                        self.unpublish_reverse(type(obj)), args=(obj.pk, ))

                # By default don't show the preview draft button unless there
                # is a `get_absolute_url` definition on the object.
                preview_draft_btn = None
                if callable(getattr(obj, 'get_absolute_url', None)):
                    preview_draft_btn = True

                # If the user has publishing permission, the object has draft
                # changes and a published version show a revert button to
                # change back to the published information.
                revert_btn = None
                if obj.is_dirty and obj.publishing_linked:
                    revert_btn = reverse(self.revert_reverse, args=(obj.pk, ))

                context.update({
                    'is_dirty': obj.is_dirty,
                    'has_been_published': obj.has_been_published,
                    'publish_btn': publish_btn,
                    'unpublish_btn': unpublish_btn,
                    'preview_draft_btn': preview_draft_btn,
                    'revert_btn': revert_btn,
                })

        # Make the original non-publishing template available to the publishing
        # change form template, so it knows what base it extends.
        # The `original_change_form_template` context variable does the same
        # job for reversion's versioning change form template.
        context.update({
            'non_publishing_change_form_template':
                self.non_publishing_change_form_template,
            'original_change_form_template':
                self.non_publishing_change_form_template,
        })

        # Hook to permit subclasses to modify context in change form
        try:
            self.update_context_for_render_change_form(context, obj)
        except AttributeError:
            pass

        # Override this admin's change form template to point to the publishing
        # admin page template, but only for long enough to render the change
        # form.
        if hasattr(type(self).change_form_template, '__get__') \
                and isinstance(self.change_form_template, (list, tuple)):
            # Special handling for class that provide multiple templates via,
            # a `change_form_template` get-only property instead of the usual
            # plain class attribute.  In this case, find the best available
            # template preferring publishing-specific templates and apply it
            # via a context variable that should be respected by Fluent's base
            # templates, which we are most likely using at this point.
            opts = self.model._meta
            app_label = opts.app_label
            extra_change_form_templates = [
                "admin/%s/%s/publishing_change_form.html" % (
                    app_label, opts.model_name),
                "admin/%s/publishing_change_form.html" % app_label,
                "admin/publishing/publishing_change_form.html"
            ]
            context['default_change_form_template'] = \
                self.find_first_available_template(
                    extra_change_form_templates + self.change_form_template)

            # Directly overriding the `change_form_template` attr here is
            # particularly messy since it can be a property getter, not
            # a normal attr, and any normal way of overriding or updating the
            # value will not work.
            try:
                self._change_form_template_getter = \
                    type(self).change_form_template.__get__
                type(self).change_form_template = \
                    context['default_change_form_template']
                has_change_form_attr_getter = True
            except AttributeError:
                # AttributeError presumably from `.__get__` hack above, in
                # which case we don't need to worry about getters and can just
                # do things the usual way
                self.change_form_template = \
                    context['default_change_form_template']
                has_change_form_attr_getter = False
        else:
            self.change_form_template = \
                "admin/publishing/publishing_change_form.html"
            has_change_form_attr_getter = False

        response = super(PublishingAdmin, self).render_change_form(
            request, context,
            add=add, change=change, form_url=form_url, obj=obj)

        # Reset change form template
        if has_change_form_attr_getter:
            type(self).change_form_template = \
                self._change_form_template_getter
        else:
            self.change_form_template = \
                self.non_publishing_change_form_template

        return response

    def publish(self, request, qs):
        # Convert polymorphic queryset instances to real ones if/when necessary
        try:
            qs = self.model.objects.get_real_instances(qs)
        except AttributeError:
            pass
        for q in qs:
            q.publish()

    def unpublish(self, request, qs):
        # Convert polymorphic queryset instances to real ones if/when necessary
        try:
            qs = self.model.objects.get_real_instances(qs)
        except AttributeError:
            pass
        for q in qs:
            q.unpublish()


class PublishingFluentPagesParentAdminMixin(_PublishingHelpersMixin):

    def get_queryset(self, request):
        """
        Show only DRAFT Fluent page items in admin.

        NOTE: We rely on the `UrlNode.status` to recognise DRAFT versus
        PUBLISHED objects, since there the top-level `UrlNode` model and
        queryset don't know about ICEKit publishing.
        """
        self.request = request

        qs = super(PublishingFluentPagesParentAdminMixin, self) \
            .get_queryset(request)
        qs = qs.filter(status=UrlNode.DRAFT)
        return qs

    queryset = get_queryset

    def status_column(self, obj):
        return self.publishing_column(obj)
    status_column.allow_tags = True
    status_column.short_description = _('Published')


class ICEKitFluentPagesParentAdminMixin(
        PublishingFluentPagesParentAdminMixin, UrlNodeParentAdmin,
):
    """ Add publishing features for FluentPage parent admin (listing) pages """
    pass
