from django.conf.urls import patterns, url
from fluent_pages.extensions import page_type_pool
from fluent_pages.integration.fluent_contents.page_type_plugins import FluentContentsPagePlugin
from fluent_pages.models import UrlNode

from . import admin, models


# Register this plugin to the page plugin pool.
@page_type_pool.register
class LayoutPagePlugin(FluentContentsPagePlugin):
    model = models.LayoutPage
    model_admin = admin.LayoutPageAdmin

