from django.contrib import admin
from icekit.content_collections.admin import TitleSlugAdmin

from . import models


class CountryFilter(admin.SimpleListFilter):
    title = 'Country'
    parameter_name = 'country'

    def lookups(self, request, model_admin):
        return ((c.id, c) for c in models.Country.objects.filter(
            id__in=model_admin.get_queryset(request).values_list(
                'country_id', flat=True
            ).distinct()
        ))

    def queryset(self, request, queryset):
        if self.value():
            return queryset.filter(country_id=self.value())
        else:
            return queryset


class GeographicLocationAdmin(admin.ModelAdmin):
    list_display = ('__unicode__', 'country_flag',)
    list_filter = (CountryFilter, )
    search_fields = ('colloquial_historical', 'country__title', 'state_province', 'city', 'neighborhood',)

    def country_flag(self, obj):
        if obj.country:
            return obj.country.title_with_flag()
        return ""

class CountryAdmin(TitleSlugAdmin):
    list_display = ('title_with_flag', 'continent', )
    list_filter = ("continent", )

    def flag(self, obj):
        return obj.iso_country.unicode_flag

admin.site.register(models.GeographicLocation, GeographicLocationAdmin)
admin.site.register(models.Country, CountryAdmin)
