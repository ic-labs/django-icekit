from django.contrib import admin
from django.contrib.contenttypes.models import ContentType


class WorkflowMixinAdmin(admin.ModelAdmin):

    def created_by_column(self, obj):
        """ Return user who first created an item in Django admin """
        first_addition_logentry = admin.models.LogEntry.objects.filter(
            object_id=obj.pk,
            content_type_id=ContentType.objects.get_for_model(obj).pk,
            action_flag=admin.models.ADDITION,
        ).get()
        return first_addition_logentry.user
    created_by_column.short_description = 'Created by'

    def last_edited_by_column(self, obj):
        """
        Return user who last edited an item in Django admin, where "edited"
        means either created (addition) or modified (change).
        """
        latest_logentry = admin.models.LogEntry.objects.filter(
            object_id=obj.pk,
            content_type_id=ContentType.objects.get_for_model(obj).pk,
            action_flag__in=[admin.models.ADDITION, admin.models.CHANGE],
        ).first()
        return latest_logentry.user
    last_edited_by_column.short_description = 'Last edited by'
