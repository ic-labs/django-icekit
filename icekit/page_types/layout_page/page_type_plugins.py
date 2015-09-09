from fluent_pages.extensions import page_type_pool

from . import admin, models
from icekit.plugins import ICEkitFluentContentsPagePlugin


# Register this plugin to the page plugin pool.
@page_type_pool.register
class LayoutPagePlugin(ICEkitFluentContentsPagePlugin):
    model = models.LayoutPage
    model_admin = admin.LayoutPageAdmin
