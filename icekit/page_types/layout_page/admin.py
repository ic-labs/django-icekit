from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin

from icekit.admin_tools.mixins import FluentLayoutsMixin, HeroMixinAdmin, \
    ListableMixinAdmin
from icekit.admin import ICEkitContentsAdmin


class UnpublishableLayoutPageAdmin(FluentLayoutsMixin, FluentContentsPageAdmin):
    raw_id_fields = ('parent',)


class LayoutPageAdmin(
    FluentLayoutsMixin,
    FluentContentsPageAdmin,
    ICEkitContentsAdmin,
    HeroMixinAdmin,
    ListableMixinAdmin,
):

    raw_id_fields = HeroMixinAdmin.raw_id_fields + ('parent',)

    base_fieldsets = FluentContentsPageAdmin.base_fieldsets[0:1] + \
                     HeroMixinAdmin.FIELDSETS + \
                     ListableMixinAdmin.FIELDSETS + \
                     FluentContentsPageAdmin.base_fieldsets[1:]
