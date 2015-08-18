from django.apps import apps
from django.contrib import admin
from django.conf import settings

from .models import BlogPost


class PostAdmin(admin.ModelAdmin):
    list_filter = ['is_active', ]


admin.site.register(BlogPost, PostAdmin)
