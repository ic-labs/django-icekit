from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin

from . import models


class ResponsePageAdmin(PlaceholderFieldAdmin):
    """
    Administration configuration for the ResponsePage model.
    """
    fieldsets = (
        (
            None, {
                'fields': ('title', 'type', 'is_active', ),
            }
        ),
        (
            'Contents', {
                'fields': ('content', ),
                'classes': ('plugin-holder', ),
            }
        )
    )

admin.site.register(models.ResponsePage, ResponsePageAdmin)
