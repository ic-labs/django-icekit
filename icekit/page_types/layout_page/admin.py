from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin

from icekit.admin import FluentLayoutsMixin
from icekit.publishing.admin import PublishingAdmin


class LayoutPageAdmin(FluentLayoutsMixin, FluentContentsPageAdmin,
                      PublishingAdmin):
    raw_id_fields = ('parent',)
