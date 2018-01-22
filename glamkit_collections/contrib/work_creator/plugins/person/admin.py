from glamkit_collections.contrib.work_creator.admin import WorkCreatorsInlineForCreators
from icekit.admin import ICEkitContentsAdmin
from icekit.admin_tools.mixins import ThumbnailAdminMixin, FluentLayoutsMixin
from django.contrib import admin
from icekit.publishing.admin import PublishingAdmin
from icekit.workflow.admin import WorkflowMixinAdmin

from . import models


class PersonCreatorAdmin(
    ICEkitContentsAdmin,
    FluentLayoutsMixin,
    ThumbnailAdminMixin,
):
    save_on_top = True
    raw_id_fields = ('portrait',)
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
    NAME_FIELDSET = ('Name', {
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

    search_fields = (
        "name_display",
        "name_sort",
        "id",
        "admin_notes",
    )
    list_display = ('thumbnail',) + PublishingAdmin.list_display \
        # WorkflowMixinAdmin.list_display
    list_display_links = list_display[:2]
    list_filter = ICEkitContentsAdmin.list_filter + (
        'workcreator__role',
    )


admin.site.register(models.PersonCreator, PersonCreatorAdmin)
