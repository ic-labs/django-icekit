from django.core.urlresolvers import reverse
from generic.admin.mixins import ThumbnailAdminMixin
import settings

def admin_link(obj):
    return "<a href='%s'>%s</a>" % (admin_url(obj), obj)

def admin_url(obj):
    return reverse(
        'admin:%s_%s_change' % (obj._meta.app_label,  obj._meta.model_name),
        args=[obj.id]
    )

class WorkThumbnailMixin(ThumbnailAdminMixin):
    thumbnail_options = settings.WORK_THUMBNAIL_OPTIONS
