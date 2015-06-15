from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin

from . import models


class SlideShowAdmin(PlaceholderFieldAdmin):
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
