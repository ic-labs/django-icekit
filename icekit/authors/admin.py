from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin
from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin
from icekit.publishing.admin import PublishingAdmin

from . import models


class AuthorAdmin(PublishingAdmin, PlaceholderFieldAdmin):
    """
    Administration configuration for `Author`.
    """
    change_form_template = 'author/admin/change_form.html'
    search_fields = ['slug', 'given_name', 'family_name']
    raw_id_fields = ['portrait', ]
    prepopulated_fields = {
        'slug': ('given_name', 'family_name' )
    }
    list_display = PublishingAdmin.list_display + ('given_name', 'family_name')
    ordering = ("family_name",)

admin.site.register(models.Author, AuthorAdmin)
