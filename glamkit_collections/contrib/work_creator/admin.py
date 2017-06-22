import six
from adminsortable2.admin import SortableInlineAdminMixin
from django.contrib import admin
from django.db.models import Count
from django.utils.safestring import mark_safe
from icekit.admin_tools.polymorphic import \
    ChildModelPluginPolymorphicParentModelAdmin
import models
from icekit.content_collections.admin import TitleSlugAdmin
from icekit.plugins.base import BaseChildModelPlugin, PluginMount
from icekit.admin import ICEkitContentsAdmin
from icekit.templatetags.icekit_tags import grammatical_join
from icekit.admin_tools.mixins import ThumbnailAdminMixin, FluentLayoutsMixin
from icekit.admin_tools.utils import admin_link, admin_url
from polymorphic.admin import PolymorphicChildModelAdmin, PolymorphicChildModelFilter

from glamkit_collections.models import Country


class WorkCreatorsInlineForCreators(admin.TabularInline, ThumbnailAdminMixin):
    model = models.WorkCreator
    raw_id_fields = ('work',)
    extra = 1
    exclude = ('order',) # doing this prevents sorting from being edited in this context.
    readonly_fields = (
        'link',
    )

    def link(self, inst):
        thumb_html = self.thumbnail(inst.work)
        if thumb_html:
            return '<a href="{0}">{1}</a>'.format(
                admin_url(inst.work),
                thumb_html,
            )
        else:
            return admin_link(inst.work)
    link.allow_tags = True

    def get_queryset(self, request):
        return super(WorkCreatorsInlineForCreators, self) \
            .get_queryset(request) \
            .filter(work__publishing_is_draft=True,
                    creator__publishing_is_draft=True)


class WorkCreatorsInlineForWorks(SortableInlineAdminMixin, WorkCreatorsInlineForCreators):
    exclude = None # re-enable sorting
    raw_id_fields = ('creator',)

    def link(self, inst):
        # NB skip ...ForCreators.thumbnail()
        thumb_html = self.thumbnail(inst.creator)
        if thumb_html:
            return '<a href="{0}">{1}</a>'.format(
                admin_url(inst.creator),
                thumb_html,
            )
        else:
            return admin_link(inst.creator)
    link.allow_tags = True

    def get_queryset(self, request):
        return super(WorkCreatorsInlineForWorks, self) \
            .get_queryset(request) \
            .filter(work__publishing_is_draft=True,
                    creator__publishing_is_draft=True)


class WorkOriginsInline(SortableInlineAdminMixin, admin.TabularInline):
    model = models.WorkOrigin
    raw_id_fields = ('geographic_location', )
    extra = 0


class WorkImageInline(
    # Some super-weirdness means that this inline doesn't appear on
    # docker-cloud staging if SortableInlineAdminMixin is enabled.
    # Giving up for now. TODO: reinstate, or choose a different sorting ui lib
    # SortableInlineAdminMixin,
    admin.TabularInline, ThumbnailAdminMixin
):
    model = models.WorkImage
    raw_id_fields = ('image', 'work')
    extra = 1
    readonly_fields = (
        'thumbnail',
    )

    def thumbnail(self, inst):
        return '<a href="{0}">{1}</a>{2}'.format(
            admin_url(inst.image),
            super(WorkImageInline, self).thumbnail(inst),
            inst.caption,
        )
    thumbnail.allow_tags = True

    def get_thumbnail_source(self, inst):
        return inst.image.image


class CreatorChildAdmin(
    PolymorphicChildModelAdmin,
    ICEkitContentsAdmin,
    FluentLayoutsMixin,
):
    base_model = models.CreatorBase
    save_on_top = True
    raw_id_fields = ('portrait', )
    exclude = ('layout', 'alt_slug',)
    # the back-end code prefers name_display for creating the slug, but
    # that field isn't required.
    prepopulated_fields = {"slug": ("name_full",)}
    inlines = [WorkCreatorsInlineForCreators] + \
        ICEkitContentsAdmin.inlines

    readonly_fields = (
        'start_date_earliest',
        'start_date_latest',
        'start_date_sort_ascending',
        'start_date_sort_descending',
        'start_date_edtf',
        'end_date_earliest',
        'end_date_latest',
        'end_date_sort_ascending',
        'end_date_sort_descending',
        'end_date_edtf',
    )

    NAME_FIELDSET =  ('Name', {
        'fields': (
            'name_full',
            'name_display',
            'name_sort',
            'slug',
        ),
    })

    DATE_FIELDSETS = (
        ("Dates", {
            'fields': (
                ('start_date_display',
                 'end_date_display',),
            ),
        }),
        ("Advanced date controls", {
            'classes': ('collapse',),
            'fields': (
                ('start_date_earliest',
                 'start_date_latest',),
                ('start_date_sort_ascending',
                 'start_date_sort_descending',),
                'start_date_edtf',

                ('end_date_earliest',
                 'end_date_latest',),
                ('end_date_sort_ascending',
                 'end_date_sort_descending',),
                'end_date_edtf',
            ),
        }),
    )


    LINKS_FIELDSET = ('Links', {
        'fields': (
            'website',
            'wikipedia_link',
        ),
    })

    fieldsets = (
        NAME_FIELDSET,
    ) + DATE_FIELDSETS + (
        LINKS_FIELDSET,
        ("Details", {
            'fields': (
                'portrait',
                'list_image',
                'boosted_search_terms',
                'admin_notes',
            ),
        }),
    )


class WorkChildAdmin(
    PolymorphicChildModelAdmin,
    ICEkitContentsAdmin,
    FluentLayoutsMixin,
    TitleSlugAdmin,
):
    base_model = models.WorkBase
    save_on_top = True
    exclude = ('layout', 'alt_slug',)
    prepopulated_fields = {"slug": ("accession_number", "title",)}
    readonly_fields = (
        "creation_date_edtf",
        'creation_date_earliest',
        'creation_date_latest',
        'creation_date_sort_ascending',
        'creation_date_sort_descending',
    )

    inlines = [WorkOriginsInline, WorkCreatorsInlineForWorks, WorkImageInline] + \
        ICEkitContentsAdmin.inlines

    DATE_FIELDSETS = (
        ("Date", {
            'fields': (
                'creation_date_display',
            ),
        }),
        ("Advanced date controls", {
            'classes': ('collapse',),
            'fields': (
                ('creation_date_earliest',
                 'creation_date_latest',),
                ('creation_date_sort_ascending',
                 'creation_date_sort_descending',),
                'creation_date_edtf',
            ),
        }),

    )
    LINKS_FIELDSET = ('Links', {
        'fields': (
            'website',
            'wikipedia_link',
        ),
    })

    fieldsets = (
        (None, {
            'fields': (
                'title',
                'subtitle',
                'slug',
                'oneliner',
            ),
        }),
    ) + DATE_FIELDSETS + (
        ("Details", {
            'fields': (
                'credit_line',
                'accession_number',
                'department',
                'list_image',
                'boosted_search_terms',
                'admin_notes',
            ),
        }),
        LINKS_FIELDSET,
    )


class WorkChildModelPlugin(six.with_metaclass(
    PluginMount, BaseChildModelPlugin)):
    """
    Mount point for ``WorkBase`` child model plugins.
    """
    model_admin = WorkChildAdmin


class CreatorChildModelPlugin(six.with_metaclass(
    PluginMount, BaseChildModelPlugin)):
    """
    Mount point for ``CreatorBase`` child model plugins.
    """
    model_admin = CreatorChildAdmin


class CreatorBaseAdmin(
    ChildModelPluginPolymorphicParentModelAdmin,
    ICEkitContentsAdmin,
    FluentLayoutsMixin,
    ThumbnailAdminMixin,
):
    base_model = models.CreatorBase
    child_model_plugin_class = CreatorChildModelPlugin
    child_model_admin = CreatorChildAdmin

    search_fields = (
        "name_display",
        "name_sort",
        "id",
        "admin_notes",
    )
    list_display = ('thumbnail',) + ICEkitContentsAdmin.list_display + (
        'works_count',
    )
    list_display_links = list_display[:2]
    list_filter = ICEkitContentsAdmin.list_filter + (
        PolymorphicChildModelFilter,
        'workcreator__role',
    )

    def get_queryset(self, request):
        return super(CreatorBaseAdmin, self).get_queryset(request)\
            .annotate(works_count=Count('works'))

    def works_count(self, inst):
        return inst.works_count
    works_count.admin_order_field = 'works_count'


class CountryFilter(admin.SimpleListFilter):
    title = 'Country'
    parameter_name = 'country'

    def lookups(self, request, model_admin):
        return ((c.id, c) for c in Country.objects.filter(
            id__in=model_admin.get_queryset(request).values_list(
                'origin_locations__country_id', flat=True
            ).distinct()
        ))

    def queryset(self, request, queryset):
        if self.value():
            return queryset.filter(origin_locations__geographic_location__country_id=self.value())
        else:
            return queryset


class WorkBaseAdmin(
    ChildModelPluginPolymorphicParentModelAdmin,
    ICEkitContentsAdmin,
    FluentLayoutsMixin,
    ThumbnailAdminMixin,
):
    base_model = models.WorkBase
    child_model_plugin_class = WorkChildModelPlugin
    child_model_admin = WorkChildAdmin

    list_display = ('thumbnail',) + ICEkitContentsAdmin.list_display + (
        'child_type_name',
        'creators_admin_links',
        'country_flags',
    )
    list_display_links = list_display[:2]
    search_fields = (
        'title',
        'slug',
        'id',
        'admin_notes',
        'accession_number',
        'credit_line',
    )
    list_filter = ICEkitContentsAdmin.list_filter + (
        PolymorphicChildModelFilter,
        'department',
        CountryFilter,
    )

    list_filter = ()

    def get_queryset(self, request):
        return super(WorkBaseAdmin, self).get_queryset(request).prefetch_related('origin_locations__country')

    def country_flags(self, inst):
        result = []
        for loc in inst.origin_locations.all():
            f = loc.flag()
            if f:
                result.append(f)
        return mark_safe("&nbsp;".join(result))
    country_flags.short_description = 'Countries'
    country_flags.admin_order_field = 'origin_locations'

    def creators_admin_links(self, inst):
        r = []
        od = inst.workcreator_set.filter(
            work__publishing_is_draft=True
        ).creators_grouped_by_role()
        for role, creators in od:
            if role:
                line = "%s: " % role
            else:
                line = "Creator: "
            line += grammatical_join([admin_link(x) for x in creators])
            r.append(line)
        return "; ".join(r)
    creators_admin_links.short_description = "Creators"
    creators_admin_links.allow_tags = True


admin.site.register(models.CreatorBase, CreatorBaseAdmin)
admin.site.register(models.WorkBase, WorkBaseAdmin)
admin.site.register(models.Role, TitleSlugAdmin)
admin.site.register(models.WorkImageType, TitleSlugAdmin)
