from django.contrib import admin

from . import models


class QuoteAdmin(admin.ModelAdmin):
    pass


admin.site.register(models.Quote, QuoteAdmin)
