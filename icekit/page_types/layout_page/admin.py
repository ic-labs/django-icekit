from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin

from icekit.admin import FluentLayoutsMixin


class LayoutPageAdmin(FluentLayoutsMixin, FluentContentsPageAdmin):
    raw_id_fields = ('parent',)
