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

    def get_render_template(self, request, fluentpage, **kwargs):
        # Allow subclasses to easily override it by specifying `render_template` after all.
        # The default, is to use the template_path from the layout object.
        return self.render_template or fluentpage.layout.template_name

