Workflow in GLAMkit
===================

GLAMkit includes a simple workflow system to help manage content
generation and `publishing <publishing.md>`__.

Quick Start
-----------

To get started with GLAMkit Workflow:

-  Add the ``icekit.workflow`` to ``INSTALLED_APPS`` (this is included
   by default)
-  Models should extend the abstract model mixin ``WorkflowStateMixin``
-  Model admins should extend ``WorkflowMixinAdmin`` and:
-  include ``WorkflowStateTabularInline`` in the admin's ``inlines``
   attribute so staff can manage workflow state relationships
-  add some or all of ``WorkflowMixinAdmin.list_display`` items to show
   workflow information in admin listing pages
-  add some or all of ``WorkflowMixinAdmin.list_filter`` items to permit
   filtering by workflow properties in admin listing pages
-  Configure email notification settings.

Workflow State
--------------

A workflow state captures the current status of items within a workflow.
Status information includes:

-  a brief description of the status, such as "Ready to review" or
   "Approved"
-  an optional user assignment, if a particular individual is
   responsible for progressing the item through to the next state in the
   workflow.

An item will generally have only a single workflow state assigned as it
moves through a workflow process, such as from "Ready to review" to
"Approved". However it is also possible to relate many workflow states
to an item to handle branching workflows if necessary.

The ``icekit.workflow.models.WorkflowState`` model allows you to assign
workflow information to any model in the system via a generic foreign
key (GFK) relationship, and to store related workflow status
information.

Reverse model relationships
~~~~~~~~~~~~~~~~~~~~~~~~~~~

To make the relationships between workflow states and a target object
navigable in reverse, the target object class should extend from the
helper abstract mixin model class
``icekit.workflow.models.WorkflowStateMixin``.

Once the reverse relationship is made navigable in this way you can look
up the workflow states associated with an item more easily using the
``workflow_states`` relationship attribute.

The ``WorkflowStateMixin`` mixin model class inlcudes extra fields to
help with workflow management in general:

- ``brief`` - document brief describing the purpose of this content
- ``admin_notes`` - Administrator's notes about this content.

Workflow Admin
--------------

WorkflowMixinAdmin
~~~~~~~~~~~~~~~~~~

The ``icekit.workflow.admin.WorkflowMixinAdmin`` provides convenient
workflow-related information and features for use in your Django admin
classes.

Admin list views columns you can add to ``list_display``:

-  ``workflow_states_column`` renders text descriptions of the workflow
   states assigned to an item
-  ``created_by_column`` renders the user who first created an item in
   the Django admin
-  ``last_edited_by_column`` renders the user to last edited (added or
   changed) an item in the admin.
-  ``brief_summary_column`` renders the first few characters of a
   workflow briefing document associated with the item.
-  ``admin_notes_summary_column`` renders the first few characters of a
   workflow admin notes document associated with the item.

NOTE: The model change tracking is based on Django admin's ``LogEntry``
mechanisms and is fairly simplistic: it will not track model changes
performed outside the admin.

Admin filter classes you can add to ``list_filter``:

-  ``WorkflowStateStatusFilter`` to show only items related to a
   workflow state with the given status, such as "Approved"
-  ``WorkflowStateAssignedToFilter`` to show only items assigned to a
   user.

WorkflowStateTabularInline
~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``icekit.workflow.admin.WorkflowStateTabularInline`` provides an
inline for assigning and managing workflow state relationships with
items in the Django admin.

Email Notifications
-------------------

ICEkit Workflow can be configured to send email notifications when the workflow
state associated with an item is added or changed.

Configure one or more target email destinations in your project settings with
``WORKFLOW_EMAIL_NOTIFICATION_TARGETS``. These target settings are very
configurable, so examples are the best way to explain:

.. code-block:: python

    WORKFLOW_EMAIL_NOTIFICATION_TARGETS = [
        # Simplest configuration is an empty dict to send email to assignee (if any)
        {},

        # All components of the email are configurable in a target
        {
            'to': 'notification-list@example.com',
            'from': 'custom-from-address@example.com',
            'subject_template': 'Custom email subject. State is now {{state}}',
            'message_template': 'Custom email body. Assigned to {{assigned_to}}',
        },

        # Send email notifications to a Slack channel that is already set up to
        # accept incoming emails. Also maps usernames to Slack @-mention syntax.
        {
            'to': 'abc123abc123@yourteamname.slack.com',
            'map_assigned_to_fn': lambda user: '@' + user.username if user else ''
        },
    ]

In addition to the per-target configuration options you can configure the default
values used.

- ``WORKFLOW_EMAIL_NOTIFICATION_DEFAULT_FROM``: Address from which workflow
  notification emails are sent. Defaults to ``settings.DEFAULT_FROM_EMAIL``

- ``WORKFLOW_EMAIL_NOTIFICATION_SUBJECT_TEMPLATE``: Template for email subject
  line. See ``icekit.workflow.appsettings`` for the default subject template.

- ``WORKFLOW_EMAIL_NOTIFICATION_MESSAGE_TEMPLATE``: Template for email body.
  See ``icekit.workflow.appsettings`` for the default message template.

The email subject and message templates above use standard Django template
syntax to interpolate values. The following data items are provided to these
templates:

- ``state``: the ``WorkflowState`` instance that has been added or changed

- ``object``: the item whose state has changed (the instance to which the
  workflow state is related)

- ``admin_url``: a full URL to the CMS admin page for the item whose state has
  changed

- ``assigned_to``: the ``User`` to which the workflow state is assigned (may be
  ``None``) or, if a mapping function is applied via the ``map_assigned_to_fn``
  target setting, the result of that mapping function.  In the Slack
  notification email example above, the value of ``assigned_to`` will be
  "@username" if a user is assigned.
