from icekit.admin import FluentLayoutsMixin
from .image import WorkImageInline
from glamkit_collections.contrib.work_creator.admin_utils import \
    WorkThumbnailMixin, admin_link


class WorkAdmin(FluentLayoutsMixin, WorkThumbnailMixin):

    inlines = [WorkImageInline]
    list_display = (
        'admin_thumbnail',
        '__unicode__',
        'artist_links',
        'date_display',
        'date_sort_latest',
    )
    list_display_links = (
        '__unicode__',
        'admin_thumbnail',
    )
    list_filter = (
        'department',
    )
    search_fields = (
        'accession_number',
        'title_display',
    )

    raw_id_fields = [
        'thumbnail_override',
    ]

    def artist_links(self, obj):
        return ",".join([admin_link(x) for x in obj.artists.all()])
    artist_links.allow_tags = True

    def get_thumbnail_source(self, obj):
        try:
            return obj.admin_hero_image.downloaded_image
        except AttributeError:
            return None

    def admin_thumbnail(self, obj):
        t = self.thumbnail(obj)
        if t:
            if obj.admin_hero_image == obj.hero_image:
                message = ""
            else:
                message = \
                    "<br><span style='font-weight: normal'>(not public)</span>"
            return "%s%s" % (t, message)
        return ""
    admin_thumbnail.allow_tags = True
    admin_thumbnail.short_description = "thumbnail"
