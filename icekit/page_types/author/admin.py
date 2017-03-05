from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin
from icekit.admin import ICEkitContentsAdmin

from . import models


class AuthorAdmin(PlaceholderFieldAdmin, ICEkitContentsAdmin):
    """
    Administration configuration for `Author`.
    """
    change_form_template = 'icekit_authors/admin/change_form.html'
    search_fields = ['slug', 'given_names', 'family_name']
    raw_id_fields = ['portrait', ]
    list_display = ICEkitContentsAdmin.list_display + \
        ('given_names', 'family_name')
    prepopulated_fields = {"slug": ("given_names", "family_name")}
    ordering = ("family_name", "given_names",)

admin.site.register(models.Author, AuthorAdmin)
