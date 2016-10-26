import six
from django.contrib import admin
from django.db.models import Count
from icekit.admin import ChildModelPluginPolymorphicParentModelAdmin
from icekit.admin_mixins import FluentLayoutsMixin
import models
from icekit.content_collections.admin import TitleSlugAdmin
from icekit.plugins.base import BaseChildModelPlugin, PluginMount
from icekit.publishing.admin import PublishingAdmin
from polymorphic.admin import PolymorphicChildModelAdmin


class CreatorChildAdmin(
    PolymorphicChildModelAdmin,
    PublishingAdmin,
    FluentLayoutsMixin,
):
    base_model = models.CreatorBase
    raw_id_fields = ['portrait', ]
    exclude = ('layout', 'alt_slug',)
    prepopulated_fields = {"slug": ("name_display",)}

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
                'boosted_search_terms',
                'admin_notes',
            ),
        }),
    )

class WorkCreatorsInline(admin.StackedInline):
    model = models.WorkCreator
    raw_id_fields = ('creator', )

class WorkChildAdmin(
    PolymorphicChildModelAdmin,
    PublishingAdmin,
    FluentLayoutsMixin,
    TitleSlugAdmin,
):
    base_model = models.WorkBase
    exclude = ('layout', 'alt_slug',)

    inlines = [WorkCreatorsInline,]

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
                'slug',
            ),
        }),
        DATE_FIELDSET,
        ORIGIN_FIELDSET,
        ("Details", {
            'fields': (
                'credit_line',
                'thumbnail_override',
                'accession_number',
                'department',
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
    FluentLayoutsMixin
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
    list_display = (
        'name_display',
        'works_count',
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
    FluentLayoutsMixin
):

    base_model = models.WorkBase
    child_model_plugin_class = WorkChildModelPlugin
    child_model_admin = WorkChildAdmin

    search_fields = (
        'title',
        'slug',
        'id',
        'admin_notes',
        'accession_id',
        'credit_line',
    )

admin.site.register(models.Role, TitleSlugAdmin)
admin.site.register(models.CreatorBase, CreatorBaseAdmin)
admin.site.register(models.WorkBase, WorkBaseAdmin)
