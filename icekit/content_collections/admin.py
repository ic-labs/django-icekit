from django.contrib import admin
from polymorphic.admin import PolymorphicChildModelFilter, \
    PolymorphicParentModelAdmin, PolymorphicChildModelAdmin

from icekit.publishing.admin import PublishingAdmin

class TitleSlugAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("title",)}
    search_fields = ('title', 'slug', 'id',)
