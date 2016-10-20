from django.contrib import admin

from icekit.utils.admin.mixins import ThumbnailAdminMixin
from polymorphic.admin import PolymorphicChildModelAdmin

from . import models


class ImageAdmin(PolymorphicChildModelAdmin):
    base_model = models.Image
    change_form_template = 'image/admin/change_form.html'

admin.site.register(models.Image, ImageAdmin)
