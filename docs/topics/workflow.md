# Workflow in ICEkit

ICEKit includes a very simple workflow system to help manage content generation
and [publishing][].


## Quick Start

To get started with ICEKit Workflow:

 * Add the `icekit.workflow` to `INSTALLED_APPS` (this is included by default)
 * Models should extend the abstract model mixin `WorkflowStepMixin`
 * Model admins should extend `WorkflowMixinAdmin` and:
   * include `WorkflowStepTabularInline` in the admin's `inlines` attribute
     so staff can manage workflow step relationships
   * add some or all of `WorkflowMixinAdmin.list_display` items to show
     workflow information in admin listing pages
   * add some or all of `WorkflowMixinAdmin.list_filter` items to permit
     filtering by workflow properties in admin listing pages


## Workflow Step

A workflow step captures the current status of items within a workflow. Status
information includes:

 * a brief description of the status, such as "Pending Review" or "Approved"
 * an optional user assignment, if a particular individual is responsible for
   progressing the item through to the next step in the workflow.

An item will generally have only a single workflow step assigned as it moves
through a workflow process, such as from "Pending Review" to "Approved".
However it is also possible to relate many workflow steps to an item to handle
branching workflows if necessary.

The `icekit.workflow.models.WorkflowStep` model allows you to assign workflow
information to any model in the system via a generic foreign key (GFK)
relationship, and to store related workflow status information.

### Reverse model relationships

To make the relationships between workflow steps and a target object navigable
in reverse, the target object class should either:

 * extend from the helper abstract mixin model class
   `icekit.workflow.models.WorkflowStepMixin`, or
 * add an equivalent `GenericRelation` relationships attribute to the model.

Once the reverse relationship is made navigable in this way you can look up the
workflow steps associated with an item more easily using the `workflow_steps`
relationship attribute.


## Workflow Admin

### WorkflowMixinAdmin

The `icekit.workflow.admin.WorkflowMixinAdmin` provides convenient workflow-related
information and features for use in your Django admin classes.

Admin list views columns you can add to `list_display`:

 * `workflow_steps_column` renders text descriptions of the workflow steps assigned
   to an item
 * `created_by_column` renders the user who first created an item in the Django admin
 * `last_edited_by_column` renders the user to last edited (added or changed) an
   item in the admin.

NOTE: The model change tracking is based on Django admin's `LogEntry`
mechanisms and is fairly simplistic: it will not track model changes performed
outside the admin.

Admin filter attributes you can add to `list_filter`:

 * `workflow_steps__status` to show only items related to a workflow step with
   the given status, such as "Approved"
 * `workflow_steps__assigned_to` to show only items assigned to a user.

NOTE: For these admin filters to work the relevant model must implement a
`GenericRelation` field named `workflow_steps`, which is easiest to do by
extending from `WorkflowStepMixin` as described above.

### WorkflowStepTabularInline

The `icekit.workflow.admin.WorkflowStepTabularInline` provides an inline for
assigning and managing workflow step relationships with items in the Django admin.


[publishing]: publishing.md
