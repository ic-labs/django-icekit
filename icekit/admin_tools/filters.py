from django.contrib import admin
from django.contrib.contenttypes.models import ContentType
from django.utils.translation import ugettext_lazy as _

# FILTERS #####################################################################


class ChildModelFilter(admin.SimpleListFilter):
    title = _('type')
    parameter_name = 'type'

    child_model_plugin_class = None

    def lookups(self, request, model_admin):
        lookups = [
            (p.content_type.pk, p.verbose_name.capitalize())
            for p in self.child_model_plugin_class.get_plugins()
        ]
        return lookups

    def queryset(self, request, queryset):
        value = self.value()
        if value:
            content_type = ContentType.objects.get_for_id(value)
            return queryset.filter(polymorphic_ctype=content_type)
