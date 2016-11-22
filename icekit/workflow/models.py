from django.db import models
from django.conf import settings
from django.contrib.contenttypes.fields import GenericForeignKey, \
    GenericRelation
from django.contrib.contenttypes.models import ContentType

from future.utils import python_2_unicode_compatible


WORKFLOW_STATUS_CHOICES = (
    # First item is the default
    ('', ''),
    ('pending_review', 'Pending Review'),
    ('approved', 'Approved'),
)

WORKFLOW_STATUS_CHOICES_DICT = dict(WORKFLOW_STATUS_CHOICES)


@python_2_unicode_compatible
class WorkflowStep(models.Model):
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
            WORKFLOW_STATUS_CHOICES_DICT[self.status],
            'by',
            str(self.assigned_to),
        ])


class WorkflowStepMixin(models.Model):
    workflow_steps = GenericRelation(WorkflowStep)

    class Meta:
        abstract = True
