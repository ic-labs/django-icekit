from django.contrib import admin
from icekit.publishing.admin import PublishingAdmin

from icekit.admin_mixins import FluentLayoutsMixin
from . import models


class ContactPersonAdmin(admin.ModelAdmin):
    pass

admin.site.register(models.ContactPerson, ContactPersonAdmin)

