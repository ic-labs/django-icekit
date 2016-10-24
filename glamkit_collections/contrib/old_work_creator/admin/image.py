from django.contrib import admin
from django.template.defaultfilters import filesizeformat
from django_object_actions import DjangoObjectActions
from glamkit_collections.contrib.work_creator.admin_utils import \
    WorkThumbnailMixin, admin_url, admin_link


class WorkImageInline(admin.TabularInline, WorkThumbnailMixin):
    """
    Implementing subclasses should add
    model = ArtworkImage
    """

    thumbnail_options = {'size': (160, 120)}
    thumbnail_field = 'downloaded_image'

    fields = (
        'order',
        'thumbnail_link',
        'views',
        'original_filesize',
        'zoom_images_folder',
    )
    readonly_fields = (
        'thumbnail_link',
        'original_filesize',
    )
    extra = 0

    def get_queryset(self, request):
        """
        Sort by view.
        """
        queryset = super(WorkImageInline, self) \
            .get_queryset(request).order_by_view()
        return queryset

    def original_filesize(self, obj):
        return filesizeformat(obj.netx_file_size or 0)

    def thumbnail_link(self, obj):
        link = admin_url(obj)
        try:
            thumb = self.thumbnail(obj)
        except:
            thumb = "None"

        return "<a href='%s'>%s</a>" % (link,  thumb)
    thumbnail_link.allow_tags = True


class WorkImageAdmin(DjangoObjectActions, admin.ModelAdmin,
                     WorkThumbnailMixin):

    list_display = (
        'thumbnail',
        'artwork',
        'netx_filesize'
    )
    list_display_links = (
        'thumbnail',
        'artwork_link',
    )

    thumbnail_field = 'downloaded_image'
    thumbnail_options = {'size': (250, 250)}

    search_fields = (
        'netx_id',
        'netx_file_name',
        'downloaded_image',
    )

    def image_link(self, obj):
        return "<a href='%s'>%s</a>" % (
            obj.downloaded_image.url, self.thumbnail(obj))
    image_link.allow_tags = True
    image_link.short_descrpition = "image"

    def artwork_link(self, obj):
        return admin_link(obj.artwork)
    artwork_link.allow_tags = True
    artwork_link.short_description = "artwork"
