from django.contrib import admin
from polymorphic.admin import PolymorphicChildModelFilter, \
    PolymorphicParentModelAdmin, PolymorphicChildModelAdmin

from icekit.publishing.admin import PublishingAdmin

class TitleSlugAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("title",)}

# Normal (non-polymorphic article admin)
class ArticleAdminBase(PublishingAdmin, TitleSlugAdmin):
    list_display = PublishingAdmin.list_display + ("published_parent", )

    def published_parent(self, obj):
        if not obj.parent.has_been_published:
            return "<span style='text-decoration: line-through'>%s</span>" % obj.parent
        return obj.parent
    published_parent.allow_tags = True


class PolymorphicArticleParentAdmin(PolymorphicParentModelAdmin, ArticleAdminBase):
    list_filter = (PolymorphicChildModelFilter,)


class PolymorphicArticleChildAdmin(PolymorphicChildModelAdmin, ArticleAdminBase):
    pass


