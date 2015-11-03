from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin

from . import models


class SlideShowAdmin(PlaceholderFieldAdmin):
    change_form_template = 'icekit/plugins/slideshow/admin/change_form.html'
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
