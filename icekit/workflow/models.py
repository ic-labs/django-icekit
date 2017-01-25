from django.db import models
from django.db.models.signals import post_save
from django.conf import settings
from django.contrib.contenttypes.fields import GenericForeignKey, \
    GenericRelation
from django.core.mail import send_mail
from django.core.urlresolvers import reverse
from django.dispatch import receiver
from django.template import Template, Context

from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site

from future.utils import python_2_unicode_compatible

from . import appsettings


WORKFLOW_STATUS_CHOICES = (
    ('new', 'New'),
    ('ready_to_review', 'Ready to review'),
    ('approved', 'Approved'),
)

# First status choice is the default
WORKFLOW_STATUS_DEFAULT = WORKFLOW_STATUS_CHOICES[0][0]


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
        default=WORKFLOW_STATUS_DEFAULT,
    )
    assigned_to = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        blank=True,
        null=True,
        help_text='User responsible for item at this stage in the workflow',
        on_delete=models.SET_NULL,
    )

    def __str__(self):
        if self.assigned_to:
            return ' '.join([
                self.get_status_display(),
                ':',
                str(self.assigned_to),
            ])
        else:
            return self.get_status_display()


class WorkflowStateMixin(models.Model):
    workflow_states = GenericRelation(WorkflowState)

    class Meta:
        abstract = True


@receiver(post_save, sender=WorkflowState)
def send_email_notifications_for_workflow_state_change(
    sender, instance, *args, **kwargs
):
    """
    Send email notifications for save events on ``WorkflowState`` based on
    settings in this module's `appsettings`.
    """
    # Short-circuit processing if we have no notification targets
    if not appsettings.WORKFLOW_EMAIL_NOTIFICATION_TARGETS:
        return

    obj = instance.content_object

    # Look up admin URL for object, getting the admin site domain from
    # ``settings.SITE_URL` if available otherwise punt to the first available
    # ``Site`` domain.
    obj_ct = ContentType.objects.get_for_model(obj)
    obj_app_name = '_'.join(obj_ct.natural_key())
    admin_path = reverse(
        'admin:%s_change' % obj_app_name, args=(obj.pk,))
    admin_domain = getattr(
        settings,
        'SITE_URL',
        Site.objects.all()[0].domain)
    if '://' not in admin_domain:
        # TODO Detect when we should use 'https' instead
        admin_domain = 'http://' + admin_domain
    admin_url = ''.join([admin_domain, admin_path])

    # Send an email notification to each target configured in settings
    for target_settings in appsettings.WORKFLOW_EMAIL_NOTIFICATION_TARGETS:
        # Send email to specific address if configured...
        if 'to' in target_settings:
            to_addresses = target_settings['to']
        # ... otherwise to the assigned user if any...
        elif instance.assigned_to:
            to_addresses = instance.assigned_to.email
        # ... otherwise skip, since we have no TO addressee
        else:
            continue
        if not isinstance(to_addresses, list):
            to_addresses = [to_addresses]

        from_address = target_settings.get(
            'from', appsettings.WORKFLOW_EMAIL_NOTIFICATION_DEFAULT_FROM)

        subject_template = target_settings.get(
            'subject_template',
            appsettings.WORKFLOW_EMAIL_NOTIFICATION_SUBJECT_TEMPLATE)

        message_template = target_settings.get(
            'message_template',
            appsettings.WORKFLOW_EMAIL_NOTIFICATION_MESSAGE_TEMPLATE)

        # Optionally map assigned user to some other identifier, such as
        # a Slack username etc.
        assigned_to_mapper = target_settings.get(
            'map_assigned_to_fn', lambda x: x)

        # Render subject and message templates
        template_context = Context({
            'state': instance,
            'object': obj,
            'admin_url': admin_url,
            'assigned_to': assigned_to_mapper(instance.assigned_to),
        })
        subject = Template(subject_template).render(template_context)
        message = Template(message_template).render(template_context)

        send_mail(subject, message, from_address, to_addresses)
