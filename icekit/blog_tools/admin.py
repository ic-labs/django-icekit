from django.apps import apps
from django.contrib import admin
from django.conf import settings


class PostAdmin(admin.ModelAdmin):
    list_filter = ['is_active', ]

default_blog_model = 'blog_tools.BlogPost'
icekit_blog_model = getattr(settings, 'ICEKIT_BLOG_MODEL', default_blog_model)
if icekit_blog_model == default_blog_model:
    post_class = apps.get_model(*icekit_blog_model.rsplit('.', 1))
    admin.site.register(post_class, PostAdmin)
