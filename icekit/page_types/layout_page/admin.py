from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin

from icekit.admin_mixins import FluentLayoutsMixin
from icekit.publishing.admin import PublishingAdmin
from icekit.utils.admin.mixins import \
    PolymorphicChildModelAdminGetParentAdminFix


class UnpublishableLayoutPageAdmin(FluentLayoutsMixin, FluentContentsPageAdmin):
    raw_id_fields = ('parent',)


class LayoutPageAdmin(
    FluentLayoutsMixin, FluentContentsPageAdmin,
    PublishingAdmin, PolymorphicChildModelAdminGetParentAdminFix
):
    raw_id_fields = ('parent',)
