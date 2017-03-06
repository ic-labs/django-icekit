Creating a new content plugin
=============================

Most ICEkit content uses the Fluent Contents system for adding an
ordered list of arbitrary content items to a given Django model (aka
"Rich Content"). A Content Item is (usually) a small model for
representing an item of content on a page and can have any fields that a
normal model has.

Content Items and Fluent Contents models (which contain them) are
related with Generic Foreign Keys.

Which content plugins are used in the project and how do I remove / add one?
----------------------------------------------------------------------------

All content plugins need to be listed in ``INSTALLED_APPS`` as they are
self contained Django apps. Each of these apps to be available for
registration must extend ``ContentItem`` for the model declaration and
``ContentPlugin`` for the registration for use.

To be able to find which plugins are installed into the project looking
in ``INSTALLED_APPS`` can start you on the process of discovery as well
as searching the project and environment for ``ContentItem`` or
``ContentPlugin``.

If the app is installed it does not necessarily mean that it is
available for use every where in the project. There is a setting named
``FLUENT_CONTENTS_PLACEHOLDER_CONFIG`` which allows each region to have
specified content plugins enabled for it. If the region is not defined
in this setting it is assume that all content plugins are appropriate
for use with it.

To add a content plugin to a project add it in ``INSTALLED_APPS`` and if
applicable define its use in ``FLUENT_CONTENTS_PLACEHOLDER_CONFIG``.

To remove a content plugin first ensure all the content instances have
been removed from your database and then remove the content plugin from
``INSTALLED_APPS`` and ``FLUENT_CONTENTS_PLACEHOLDER_CONFIG``.

ICEkit also has a simpler ``PublishableArticle`` model, which implements
a Publishable Fluent Contents model - ie it's a straightforward Django
model that happens to have rich content and be publishable. This is
useful for more normal Django collections-of-things, like Press
Releases, People, Articles.

It's common to have a collecton of items with a paired
``AbstractLayoutPage`` Page to list/navigate the collection. See the
``authors`` app for a worked example of this.

Adding help text to a Placeholder
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can also add help text to a placeholder, by specifying a
``'help_text'`` entry for the placeholder in
``settings.FLUENT_CONTENTS_PLACEHOLDER_CONFIG``:

::

    FLUENT_CONTENTS_PLACEHOLDER_CONFIG = {
        ...
        'about_the_show': {
            'plugins':  (
                'RawHTMLPlugin',
                'TextPlugin',
            ),
            'help_text': "About the show can <em>only</em> have text and HTML."
        },
        ...
    }

The placeholder help text displays when its tab is selected.

Note: Placeholder help text is currently only implemented for Models
that inherit ICEkit's ``LayoutFieldMixin``, and with an Admin that
inherits from ``FluentLayoutsMixin``. This is because
``icekit.admin.LayoutAdmin`` defines a URL/view that includes the help
text, and the ``icekit/static/icekit/admin/js/fluent_layouts.js`` file
injects the help text into the DOM.

Adding rich content to a model.
-------------------------------

You can add modular content to any model, not only hierarchical ``Page``
models, with two mixin classes:

::

    # models.py

    from icekit.mixins import FluentFieldsMixin

    class MyModel(FluentFieldsMixin, MyModelBase):
        ...

    # admin.py

    from icekit.admin_tools.mixins import FluentLayoutsMixin

    class MyModelAdmin(FluentLayoutsMixin, MyModelAdminBase):
        ...

``FluentFieldsMixin`` will add a ``layout`` field to your model, so
you'll need a migration for this change:

::

    $ manage.py makemigrations myapp
    $ manage.py migrate

Creating New Plugins
--------------------

We should endeavor to use the reference plugins as-is to keep things
DRY.

When they don't entirely fit the requirements, we should try to enhance
them in a backwards compatible way to support the new requirements
without breaking any existing projects that might be using them.

If the requirements are drastically divergent and can't support both the
current and new requirements, we can make a new plugin.

If the new requirements are widely reusable, we should make a new
reference plugin in ``icekit``, or perhaps in another repository.

If the new requirements are a different flavour of the same thing that
will almost certainly only apply to one client or project, then we can
make a new plugin in the project.

Before we make a new plugin in the project, we should consider that:

1. A fully customised solution is warranted by the requirements and
   budget;

2. Future projects won't be able to benefit from custom plugins
   developed for one project. It is rarely the case that we refactor
   project plugins into ``icekit`` after a project has ended.

3. The project won't get "free" plugin enhancements when upgrading to a
   new version of ICEkit.

4. We may end up re-implementing very similar plugins again and again in
   different projects.

Frequently Asked Questions
--------------------------

How do I target a specific page layout with a plugin?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Defining a 'placeholder
slot' <https://django-fluent-contents.readthedocs.org/en/latest/templatetags.html#cms-page-placeholders>`__

`Configuring the available
plugins <https://django-fluent-contents.readthedocs.org/en/latest/configuration.html#configuration>`__

How do I make changes to the fields on a plugin that lives in the venv? How do I add/remove fields in the admin?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Inherit from the plugin, make changes as a subclass, use ``fieldsets``
(property on the content plugin) to hide fields.

Refer to
`fluent-contents <https://django-fluent-contents.readthedocs.org/en/latest/index.html>`__
- specifically `Customizing the admin
interface <https://django-fluent-contents.readthedocs.org/en/latest/newplugins/admin.html>`__
