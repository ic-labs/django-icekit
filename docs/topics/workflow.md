# Workflow in ICEkit

ICEKit includes a very simple workflow system to help manage content generation
and [publishing][].

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
