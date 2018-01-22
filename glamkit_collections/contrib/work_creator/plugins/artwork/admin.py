from django.contrib import admin
from glamkit_collections.contrib.work_creator.admin import (
    WorkOriginsInline, WorkCreatorsInlineForWorks, WorkImageInline
)
from icekit.admin import ICEkitContentsAdmin
from icekit.admin_tools.mixins import ThumbnailAdminMixin, FluentLayoutsMixin
from icekit.admin_tools.utils import admin_link
from icekit.publishing.admin import PublishingAdmin
from icekit.templatetags.icekit_tags import grammatical_join
from icekit.workflow.admin import WorkflowMixinAdmin

from . import models


class ArtworkAdmin(
    ICEkitContentsAdmin,
    FluentLayoutsMixin,
    ThumbnailAdminMixin,
):
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
        ('Medium', {
            'fields': (
                'medium_display',
            )
        }),
        ('Dimensions', {
            'fields': (
                'dimensions_is_two_dimensional',
                'dimensions_display',
                'dimensions_extent',
                'dimensions_width_cm',
                'dimensions_height_cm',
                'dimensions_depth_cm',
                'dimensions_weight_kg',
            )
        }),
    )

    list_display = ('thumbnail',) + PublishingAdmin.list_display
    # list_display = ('thumbnail',) + PublishingAdmin.list_display + WorkflowMixinAdmin.list_display + ('creators_admin_links',)
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
        'department',
    )

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


admin.site.register(models.Artwork, ArtworkAdmin)
