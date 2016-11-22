from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.admin import GenericTabularInline
from django import forms

from . import models


class WorkflowStepForm(forms.ModelForm):

    def __init__(self, *args, **kwargs):
        super(WorkflowStepForm, self).__init__(*args, **kwargs)
        # Limit user choices for `assigned_to` field to active staff users
        User = get_user_model()
        staff_user_pks = [
            u.pk for u in User.objects.filter(is_active=True, is_staff=True)]
        self.fields['assigned_to'].choices = \
            [choice for choice in self.fields['assigned_to'].choices
             if not choice[0] or choice[0] in staff_user_pks]


class WorkflowStepTabularInline(GenericTabularInline):
    model = models.WorkflowStep
    form = WorkflowStepForm

    # Permit only a sinlge workflow step relationships now for simplicity
    extra = 0
    min_num = 1
    max_num = 1
    can_delete = False


class WorkflowMixinAdmin(admin.ModelAdmin):

    def _get_obj_ct(self, obj):
        """ Look up and return object's content type and cache for reuse """
        if not hasattr(obj, '_wfct'):
            obj._wfct = ContentType.objects.get_for_model(obj)
        return obj._wfct

    def workflow_steps_column(self, obj):
        """ Return text description of workflow steps assigned to object """
        workflow_steps = models.WorkflowStep.objects.filter(
            content_type=self._get_obj_ct(obj),
            object_id=obj.pk,
        )
        return ', '.join([unicode(wfs) for wfs in workflow_steps])
    workflow_steps_column.short_description = 'Workflow Steps'

    def created_by_column(self, obj):
        """ Return user who first created an item in Django admin """
        first_addition_logentry = admin.models.LogEntry.objects.filter(
            object_id=obj.pk,
            content_type_id=self._get_obj_ct(obj).pk,
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
            content_type_id=self._get_obj_ct(obj).pk,
            action_flag__in=[admin.models.ADDITION, admin.models.CHANGE],
        ).first()
        return latest_logentry.user
    last_edited_by_column.short_description = 'Last edited by'
