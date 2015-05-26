"""
Admin configuration for ``eventkit`` app.
"""

# Define `list_display`, `list_filter` and `search_fields` for each model.
# These go a long way to making the admin more usable.

from django.contrib import admin
from polymorphic.admin import \
    PolymorphicParentModelAdmin, PolymorphicChildModelAdmin

from eventkit import models


class EventChildAdmin(PolymorphicChildModelAdmin):
    base_model = models.Event


class EventAdmin(PolymorphicParentModelAdmin):
    base_model = models.Event
    list_filter = ('all_day', 'starts', 'ends')
    list_display = ('__unicode__', 'all_day', 'starts', 'ends')
    search_fields = ('title', )

    def get_child_models(self):
        # TODO: Registration system for event plugins.
        return ()

admin.site.register(models.Event, EventAdmin)


class RecurrenceRuleAdmin(admin.ModelAdmin):
    model = models.RecurrenceRule

admin.site.register(models.RecurrenceRule, RecurrenceRuleAdmin)
