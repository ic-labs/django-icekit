from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.admin import GenericTabularInline
from django import forms

from . import models


def get_users_for_assigned_to():
    """ Return a list of users who can be assigned to workflow states """
    User = get_user_model()
    return User.objects.filter(is_active=True, is_staff=True)


class WorkflowStateStatusFilter(admin.SimpleListFilter):
    title = 'Workflow Status'
    parameter_name = 'workflow_status'

    def lookups(self, request, model_admin):
        return models.WORKFLOW_STATUS_CHOICES

    def queryset(self, request, queryset):
        if self.value() is None:
            return queryset

        value = self.value()

        # If admin is for a `WorkflowStateMixin` subclass use simple query...
        if issubclass(queryset.model, models.WorkflowStateMixin):
            return queryset.filter(
                workflow_states__status=value)

        # ...if admin is not for a `WorkflowStateForm` subclass we must iterate
        # over child model instances to find the items that should be filterd
        wf_state_ct_pks = set([
            (wfstate.content_type_id, wfstate.object_id)
            for wfstate in models.WorkflowState.objects.filter(status=value)
        ])
        pks_to_exclude = []
        for item in queryset.get_real_instances():
            if (item.polymorphic_ctype_id, item.pk) not in wf_state_ct_pks:
                pks_to_exclude.append(item.pk)
        return queryset.exclude(pk__in=pks_to_exclude)


class WorkflowStateAssignedToFilter(admin.SimpleListFilter):
    title = 'Assigned To'
    parameter_name = 'assigned_to'

    def lookups(self, request, model_admin):
        return [
            (user.pk, unicode(user))
            for user in get_users_for_assigned_to()
        ]

    def queryset(self, request, queryset):
        if self.value() is None:
            return queryset

        value = self.value()

        # If admin is for a `WorkflowStateMixin` subclass use simple query...
        if issubclass(queryset.model, models.WorkflowStateMixin):
            return queryset.filter(
                workflow_states__assigned_to=value)

        # ...if admin is not for a `WorkflowStateForm` subclass we must iterate
        # over child model instances to find the items that should be filterd
        wf_state_ct_pks = set([
            (wfstate.content_type_id, wfstate.object_id)
            for wfstate in models.WorkflowState.objects.filter(
                assigned_to=value)
        ])
        pks_to_exclude = []
        for item in queryset.get_real_instances():
            if (item.polymorphic_ctype_id, item.pk) not in wf_state_ct_pks:
                pks_to_exclude.append(item.pk)
        return queryset.exclude(pk__in=pks_to_exclude)


class WorkflowStateForm(forms.ModelForm):

    def __init__(self, *args, **kwargs):
        super(WorkflowStateForm, self).__init__(*args, **kwargs)
        # Limit user choices for `assigned_to` field to active staff users
        user_pks = [u.pk for u in get_users_for_assigned_to()]
        self.fields['assigned_to'].choices = \
            [choice for choice in self.fields['assigned_to'].choices
             if not choice[0] or choice[0] in user_pks]


class WorkflowStateTabularInline(GenericTabularInline):
    model = models.WorkflowState
    form = WorkflowStateForm

    # Permit only a sinlge workflow state relationships now for simplicity
    extra = 0
    min_num = 1
    max_num = 1
    can_delete = False


class WorkflowMixinAdmin(admin.ModelAdmin):
    list_display = (
        "last_edited_by_column", "workflow_states_column")
    list_filter = (
        WorkflowStateStatusFilter, WorkflowStateAssignedToFilter)

    def _get_obj_ct(self, obj):
        """ Look up and return object's content type and cache for reuse """
        if not hasattr(obj, '_wfct'):
            # Use polymorpic content type if available
            if hasattr(obj, 'polymorphic_ctype'):
                obj._wfct = obj.polymorphic_ctype
            else:
                obj._wfct = ContentType.objects.get_for_model(obj)
        return obj._wfct

    def workflow_states_column(self, obj):
        """ Return text description of workflow states assigned to object """
        workflow_states = models.WorkflowState.objects.filter(
            content_type=self._get_obj_ct(obj),
            object_id=obj.pk,
        )
        return ', '.join([unicode(wfs) for wfs in workflow_states])
    workflow_states_column.short_description = 'Workflow States'

    def created_by_column(self, obj):
        """ Return user who first created an item in Django admin """
        try:
            first_addition_logentry = admin.models.LogEntry.objects.filter(
                object_id=obj.pk,
                content_type_id=self._get_obj_ct(obj).pk,
                action_flag=admin.models.ADDITION,
            ).get()
            return first_addition_logentry.user
        except admin.models.LogEntry.DoesNotExist:
            return None
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
        if latest_logentry:
            return latest_logentry.user
        else:
            return None
    last_edited_by_column.short_description = 'Last edited by'
