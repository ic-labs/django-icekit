from django.contrib import admin
from fluent_contents.admin import PlaceholderFieldAdmin
from icekit.contrib.navigation.models import Navigation


class NavigationAdmin(PlaceholderFieldAdmin):
    prepopulated_fields = {'slug': ('name',), }
    list_display = ('name', 'slug',)
    search_fields = ('name', 'slug',)

    def has_change_permission(self, request, obj=None):
        return request.user.is_superuser

    def has_delete_permission(self, request, obj=None):
        return request.user.is_superuser

admin.site.register(Navigation, NavigationAdmin)
