from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin

from icekit.admin import ICEkitContentsAdmin
from icekit.admin_tools.mixins import PreviewAdminMixin

from . import models


class SlideShowAdmin(PlaceholderFieldAdmin, ICEkitContentsAdmin, PreviewAdminMixin):
    change_form_template = 'icekit/plugins/slideshow/admin/change_form.html'
    list_display = ICEkitContentsAdmin.list_display[:1] + ('preview', ) + ICEkitContentsAdmin.list_display[1:]
    list_display_links = ('preview', ) + ICEkitContentsAdmin.list_display_links
    fieldsets = (
        (
            None, {
                'fields': ('title', 'show_title', ),
            }
        ),
        (
            'Contents', {
                'fields': ('content', ),
                'classes': ('plugin-holder', ),
            }
        )
    )

admin.site.register(models.SlideShow, SlideShowAdmin)
