Workflow in ICEkit
==================

ICEKit includes a very simple workflow system to help manage content
generation and `publishing <publishing.md>`__.

Quick Start
-----------

To get started with ICEKit Workflow:

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
