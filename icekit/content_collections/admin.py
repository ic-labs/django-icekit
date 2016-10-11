from django.contrib import admin
from polymorphic.admin import PolymorphicChildModelFilter, \
    PolymorphicParentModelAdmin, PolymorphicChildModelAdmin

from icekit.publishing.admin import PublishingAdmin

class TitleSlugAdmin(admin.ModelAdmin):
    prepopulated_fields = {"slug": ("title",)}

# # Normal (non-polymorphic content collection admin)
# class CollectedContentAdminBase(PublishingAdmin, TitleSlugAdmin):
#     list_display = PublishingAdmin.list_display + ("published_parent", )
#
#     def get_queryset(self, request):
#         qs = super(CollectedContentAdminBase, self)
#         return qs\
#             .get_queryset(request)\
#             .select_related('parent', 'parent__published_link', )
#
#     def published_parent(self, obj):
#         if not obj.parent.has_been_published:
#             return "<span style='text-decoration: line-through'>%s</span>" % obj.parent
#         return obj.parent
#     published_parent.allow_tags = True
#
#
# class CollectedContentParentAdmin(PolymorphicParentModelAdmin, CollectedContentAdminBase):
#     list_filter = (PolymorphicChildModelFilter,)
#
#
# class CollectedContentChildAdmin(PolymorphicChildModelAdmin, CollectedContentAdminBase):
#     pass
