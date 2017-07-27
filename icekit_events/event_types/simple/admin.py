from icekit_events.admin import EventWithLayoutsAdmin
from icekit.admin_tools.mixins import ListableMixinAdmin, HeroMixinAdmin


class SimpleEventAdmin(
    EventWithLayoutsAdmin,
    ListableMixinAdmin,
    HeroMixinAdmin
):
    raw_id_fields = EventWithLayoutsAdmin.raw_id_fields + \
        HeroMixinAdmin.raw_id_fields

    fieldsets = EventWithLayoutsAdmin.fieldsets + \
        HeroMixinAdmin.FIELDSETS + \
        ListableMixinAdmin.FIELDSETS
