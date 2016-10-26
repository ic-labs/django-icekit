import six
from adminsortable2.admin import SortableInlineAdminMixin
from django.contrib import admin
from django.db.models import Count
from icekit.admin import ChildModelPluginPolymorphicParentModelAdmin
from icekit.admin_mixins import FluentLayoutsMixin
import models
from icekit.content_collections.admin import TitleSlugAdmin
from icekit.plugins.base import BaseChildModelPlugin, PluginMount
from icekit.publishing.admin import PublishingAdmin
from icekit.templatetags.icekit_tags import grammatical_join
from icekit.utils.admin.mixins import ThumbnailAdminMixin
from icekit.utils.admin.urls import admin_link, admin_url
from polymorphic.admin import PolymorphicChildModelAdmin, PolymorphicChildModelFilter



class WorkCreatorsInlineForCreators(admin.TabularInline, ThumbnailAdminMixin):
    model = models.WorkCreator
    raw_id_fields = ('work',)
    extra = 1
    exclude = ('order',)
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


class WorkCreatorsInlineForWorks(SortableInlineAdminMixin, WorkCreatorsInlineForCreators):
    exclude = None
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


class WorkImageInline(SortableInlineAdminMixin, admin.TabularInline, ThumbnailAdminMixin):
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
    PublishingAdmin,
    FluentLayoutsMixin,
):
    base_model = models.CreatorBase
    raw_id_fields = ['portrait', ]
    exclude = ('layout', 'alt_slug',)
    prepopulated_fields = {"slug": ("name_display",)}
    inlines = [WorkCreatorsInlineForCreators,]


    NAME_FIELDSET =  ('Name', {
        'fields': (
            'name_display',
            'slug',
            'name_sort',
        ),
    })
    LINKS_FIELDSET = ('Links', {
        'fields': (
            'website',
            'wikipedia_link',
        ),
    })

    fieldsets = (
        NAME_FIELDSET,
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
    PublishingAdmin,
    FluentLayoutsMixin,
    TitleSlugAdmin,
):
    base_model = models.WorkBase
    exclude = ('layout', 'alt_slug',)
    prepopulated_fields = {"slug": ("accession_number", "title",)}

    inlines = [WorkCreatorsInlineForWorks, WorkImageInline]

    DATE_FIELDSET = ("Date", {
        'fields': (
            'date_display',
            'date_edtf',
        ),
    })
    ORIGIN_FIELDSET = ("Origin", {
        'fields': (
            'origin_continent',
            'origin_country',
            'origin_state_province',
            'origin_city',
            'origin_neighborhood',
            'origin_colloquial',
        ),
    })
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
                'one_liner',
            ),
        }),
        DATE_FIELDSET,
        ORIGIN_FIELDSET,
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
    PublishingAdmin,
    FluentLayoutsMixin,
    ThumbnailAdminMixin,
):
    base_model = models.CreatorBase
    child_model_plugin_class = CreatorChildModelPlugin
    child_model_admin = CreatorChildAdmin

    search_fields = (
        "name_display",
        "name_full",
        "id",
        "admin_notes",
    )
    list_display = ('thumbnail',) + PublishingAdmin.list_display + (
        'works_count',
    )
    list_display_links = list_display[:2]
    list_filter = PublishingAdmin.list_filter + (
        PolymorphicChildModelFilter,
        'workcreator__role',
    )

    def get_queryset(self, request):
        return super(CreatorBaseAdmin, self).get_queryset(request)\
            .annotate(works_count=Count('works'))

    def works_count(self, inst):
        return inst.works_count
    works_count.admin_order_field = 'works_count'


class WorkBaseAdmin(
    ChildModelPluginPolymorphicParentModelAdmin,
    PublishingAdmin,
    FluentLayoutsMixin,
    ThumbnailAdminMixin,
):
    base_model = models.WorkBase
    child_model_plugin_class = WorkChildModelPlugin
    child_model_admin = WorkChildAdmin

    list_display = ('thumbnail',) + PublishingAdmin.list_display + (
        'creators_admin_links',
        'country_flag',
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
    list_filter = PublishingAdmin.list_filter + (
        PolymorphicChildModelFilter,
        'department',
        'origin_continent',
        'origin_country',
    )

    def country_flag(self, inst):
        return inst.origin_country.unicode_flag
    country_flag.short_description = 'Country'
    country_flag.admin_order_field = 'origin_country'

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
