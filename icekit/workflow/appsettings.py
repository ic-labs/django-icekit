# Configuration options for ``workflow`` app, refer to docs/topics/workflow.md
from django.conf import settings


WORKFLOW_EMAIL_NOTIFICATION_TARGETS = getattr(
    settings,
    'WORKFLOW_EMAIL_NOTIFICATION_TARGETS',
    []  # No notification targets by default
)

WORKFLOW_EMAIL_NOTIFICATION_DEFAULT_FROM = getattr(
    settings,
    'WORKFLOW_EMAIL_NOTIFICATION_DEFAULT_FROM',
    settings.DEFAULT_FROM_EMAIL
)

WORKFLOW_EMAIL_NOTIFICATION_SUBJECT_TEMPLATE = getattr(
    settings,
    'WORKFLOW_EMAIL_NOTIFICATION_SUBJECT_TEMPLATE',
    settings.EMAIL_SUBJECT_PREFIX +
    """[Workflow] <{{object}}> set to <{{state.get_status_display}}> assigned to {{assigned_to}}"""
)

WORKFLOW_EMAIL_NOTIFICATION_MESSAGE_TEMPLATE = getattr(
    settings,
    'WORKFLOW_EMAIL_NOTIFICATION_MESSAGE_TEMPLATE',
"""
<{{object}}> set to <{{state.get_status_display}}> assigned to {{assigned_to}}.

Admin URL: {{admin_url}}
"""
)
