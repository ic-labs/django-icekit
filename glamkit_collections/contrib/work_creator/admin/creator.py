from django.contrib import admin
from icekit.admin import FluentLayoutsMixin

from glamkit_collections.contrib.work_creator.admin_utils import \
    WorkThumbnailMixin, admin_link, admin_url


class WorkInline(admin.TabularInline, WorkThumbnailMixin):
    """
    Implementing subclasses should add

    model = ArtworkArtist
    """

    thumbnail_field = 'admin_hero_image'

    fields = (
        'thumbnail_link',
        'role',
    )
    readonly_fields = (
        'thumbnail_link',
    )
    extra = 0

    def artwork_link(self, obj):
        return admin_link(obj.artwork)
    artwork_link.allow_tags = True

    def has_delete_permission(self, request, obj=None):
        return False

    def has_add_permission(self, request):
        return False

    def thumbnail_link(self, obj):
        link = admin_url(obj.artwork)
        style = ""
        return "<a href='%s' style='%s'>%s</a>" % (
            link, style, self.thumbnail(obj) or "No thumbnail")
    thumbnail_link.allow_tags = True


class CreatorAdmin(FluentLayoutsMixin):
    """
    Implementing subclasses should add

    inlines = [WorkInline]
    """

    search_fields = (
        "name_full",
    )
    list_display = (
        'name_display',
        'artwork_count',
    )

    raw_id_fields = ['portrait', ]
