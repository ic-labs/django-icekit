# Content and Page Type Plugins

The `icekit.plugins` (content plugins) and `icekit.page_types` (page type
plugins) packages contain generic reference implementations for many types of
content and pages that we might need in a project.

# Adding New Plugins

We should endeavor to use the reference plugins as-is to keep things DRY.

When they don't entirely fit the requirements, we should try to enhance them in
a backwards compatible way to support the new requirements without breaking any
existing projects that might be using them.

If the requirements are drastically divergent and can't support both the
current and new requirements, we can make a new plugin.

If the new requirements are legitimately a different thing, we should make a
new reference plugin in `icekit`.

If the new requirements are a different flavour of the same thing that will
almost certainly only apply to one client or project, then we can make a new
plugin in the project.

Before we make a new plugin in the project, we should consider that:

 1. A fully customised solution is warranted by the requirements and budget;

 2. Future projects won't be able to benefit from custom plugins developed for
    one project. It is rarely the case that we refactor project plugins into
    `icekit` after a project has ended.

 3. The project won't get "free" plugin enhancements when upgrading to a new
    version of ICEkit.

 4. We may end up re-implementing very similar plugins again and again in
    different projects.
