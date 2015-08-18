from django.apps import apps
from django.contrib import admin
from django.conf import settings


class PostAdmin(admin.ModelAdmin):
    list_filter = ['is_active', ]


icekit_blog_model = getattr(settings, 'ICEKIT_BLOG_MODEL', 'blog_tools.BlogPost')
post_class = apps.get_model(*icekit_blog_model.rsplit('.', 1))
admin.site.register(post_class, PostAdmin)
