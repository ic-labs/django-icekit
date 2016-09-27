from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin
from icekit.articles.admin import ArticleAdminBase
from . import models


class AuthorAdmin(ArticleAdminBase, PlaceholderFieldAdmin):
    """
    Administration configuration for `Author`.
    """
    change_form_template = 'author/admin/change_form.html'
    search_fields = ['slug', 'given_name', 'family_name']
    raw_id_fields = ['portrait', ]
    list_display = ArticleAdminBase.list_display + ('given_name', 'family_name')
    ordering = ("family_name",)

admin.site.register(models.Author, AuthorAdmin)
