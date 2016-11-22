from django.db import models
from django.conf import settings
from django.contrib.contenttypes.fields import GenericForeignKey, \
    GenericRelation
from django.contrib.contenttypes.models import ContentType

from future.utils import python_2_unicode_compatible


WORKFLOW_STATUS_CHOICES = (
    # First item is the default
    ('', ''),
    ('ready_to_review', 'Ready to review'),
    ('approved', 'Approved'),
)


@python_2_unicode_compatible
class WorkflowState(models.Model):
    # Generic Foreign Key fields to arbitrary object
    content_type = models.ForeignKey(ContentType)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey(
        'content_type',
        'object_id',
        # Permit references to proxy models
        for_concrete_model=False,
    )

    status = models.CharField(
        max_length=254,
        choices=WORKFLOW_STATUS_CHOICES,
        default=WORKFLOW_STATUS_CHOICES[0][0],
    )
    assigned_to = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        blank=True,
        null=True,
        help_text='User responsible for item at this stage in the workflow',
    )

    def __str__(self):
        return ' '.join([
            self.get_status_display(),
            'by',
            str(self.assigned_to),
        ])


class WorkflowStateMixin(models.Model):
    workflow_states = GenericRelation(WorkflowState)

    class Meta:
        abstract = True
