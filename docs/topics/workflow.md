# Workflow in ICEkit

ICEKit includes a very simple workflow system to help manage content generation
and [publishing][].


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


## Workflow Admin

The `icekit.workflow.admin.WorkflowMixinAdmin` provides convenient workflow-related
information and features for use in your Django admin classes.

Admin list views columns you can add to `list_display`:

* `created_by_column` renders the user who first created an item in the Django admin
* `last_edited_by_column` renders the user to last edited (added or changed) an
  item in the admin.

NOTE: The model change tracking is based on Django admin's `LogEntry`
mechanisms and is fairly simplistic: it will not track model changes performed
outside the admin.


[publishing]: publishing.md
