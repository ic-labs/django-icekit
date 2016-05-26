from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin

from icekit.admin import FluentLayoutsMixin
from icekit.publishing.admin import PublishingAdmin


class UnpublishableLayoutPageAdmin(FluentLayoutsMixin, FluentContentsPageAdmin):
    raw_id_fields = ('parent',)


class LayoutPageAdmin(FluentLayoutsMixin, FluentContentsPageAdmin,
                      PublishingAdmin):
    raw_id_fields = ('parent',)
