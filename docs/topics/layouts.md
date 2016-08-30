## Flexible Layouts

The `Layout` model links a template to all the models that can use it.

The template for a layout should define placeholders for modular content:

    {# layouts/default.html #}

    {% load fluent_contents_tags %}

    <div id="main">
        {% page_placeholder obj "main" %}
    </div>
    <div id="sidebar">
        {% page_placeholder obj "sidebar" %}
    </div>

Models that have modular content will have a `layout` field in the admin change
form, allowing the selection of a layout that is compatible with that model.

### TemplateNameField

`TemplateNameField` behaves like a choice field and populates its list of
available template names by plugins, if the `plugin_class` kwarg is given.

The `Layout.template_name` field uses the `TemplateNameFieldChoicesPlugin`
mount point, and ICEkit ships with several plugins.

#### AppModelDefaultLayoutsPlugin

Adds default app and model templates for related models.

For example, if a `foo.Bar` model had a `ForeignKey('icekit.Layout')` field,
this plugin would return the following choices:

    ('foo/layouts/default.html', 'Foo: Default'),
    ('foo/bar/layouts/default.html', 'Foo: Bar'),
    ('foo/bar/layouts/baz.html', 'Foo: Baz'),  # Polymorphic child model

#### FileSystemLayoutsPlugin

Adds templates from one or more directories on the file system.

Directories can be specified in the `ICEKIT['LAYOUT_TEMPLATES']` setting,
which should be a list of 3-tuples, each containing a label prefix, a
templates directory that will be searched by the installed template
loaders, and a template name prefix.

The templates directory and template name prefix are combined to get the
source directory. All files in this directory will be included.

The template name prefix and the source file path, relative to the source
directory, are combined to get the template name.

The label prefix and source file path are combined to get the label.

Given the following directory structure:

    /myproject/templates/myproject/layouts/foo.html
    /myproject/templates/myproject/layouts/bar/baz.html

These settings:

    ICEKIT = {
        'LAYOUT_TEMPLATES': (
            ('My Project', '/myproject/templates, 'myproject/layouts'),
        ),
    }

Would result in these choices::

    ('myproject/layouts/foo.html', 'My Project: foo.html')
    ('myproject/layouts/bar/baz.html', 'My Project: bar/baz.html')

#### Creating a Custom TemplateNameFieldChoicesPlugin

Subclass `TemplateNameFieldChoicesPlugin` and define a `get_choices()` method
that returns a list of 2-tuples, each containing a template name and a label.

The `field` attribute will be the `TemplateNameField` to which the plugin mount
point is attached.
