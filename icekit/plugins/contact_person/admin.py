from django.contrib import admin

from . import models


class ContactPersonAdmin(admin.ModelAdmin):
    pass

admin.site.register(models.ContactPerson, ContactPersonAdmin)
