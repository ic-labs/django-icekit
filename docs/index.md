# Overview

A modular content CMS by [Interaction Consortium], built on top of
[django-fluent-pages] and [django-fluent-contents].

Includes the following features:

  * Flexible layouts system.
      * Define modular content placeholders in layout templates.
      * Enable different layouts for different `ContentType`s.
      * Switch layouts at the instance level.
      * TODO: Add layouts and modular content to 3rd party models without
        migrations.
  * Page type plugins:
      * `article_page` - integrates with Fluent Pages
      * `layout_page` - integrates with our layouts system.
      * `search_page` - integrates with [Haystack].
  * Modular content plugins:
      * `blog_post` - TODO
      * `brightcove` - TODO
      * `child_pages` - TODO
      * `faq` - TODO
      * `horizontal_rule` - TODO
      * `image` - TODO
      * `instagram_embed` - TODO
      * `map` - TODO
      * `map_with_text` - TODO
      * `oembed_with_caption` - TODO
      * `page_anchor` - TODO
      * `page_anchor_list` - TODO
      * `quote` - TODO
      * `reusable_form` - TODO
      * `reusable_quote` - TODO
      * `slideshow` - TODO
      * `twitter_embed` - TODO

## Table of Contents

  * [Changelog]
  * [Contributing]

## Installation

Add to your `setup.py`:

    setuptools.setup(
        ...
        install_requires=[
            ...
            'django-icekit[brightcove,dev,search,test]',  # Omit unwanted optional extras.
        ],
    )

If you want to use `Django 1.7` you need to add the optional extra `django17`:

    setuptools.setup(
        ...
        install_requires=[
            ...
            'django-icekit[brightcove,dev,search,test,django17]',  # Omit unwanted optional extras.
        ],
    )

Reinstall your project to pickup the new requirements:

    $ pip install -e .

NOTE: While ICEkit is not yet released on PyPI, install it manually:

    $ pip install -e git+ssh://git@github.com/ixc/django-icekit.git@develop#egg=django-icekit[brightcove,dev,search,test]  # Omit unwanted optional extras.

Add to the `INSTALLED_APPS` setting:

    INSTALLED_APPS += ('icekit', )

## Flexible Layouts

The `Layout` model links a template to all the `ContentType`s that are allowed
to use it.

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
form, that shows `Layout`s that are compatible with that `ContentType`.

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

#### FileSystemLayoutsPlugin

Adds templates from one or more directories on the file system.

Directories can be specified in the ``ICEKIT['LAYOUT_TEMPLATES']`` setting,
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

### The Layout Model

The `Layout` model links a template to all the `ContentType`s that are allowed
to use it.

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
form, that will only show layouts for the model being edited.

## Article Page Type

The article page type is designed to be used with ``fluent_pages`` to enable
add it to `INSTALLED_APPS` setting:

    INSTALLED_APPS += (
        'icekit.page_types.article',
    )

## Layout Page Type

Integrates [FluentContentsPage] and our flexible layouts system.

Add to the `INSTALLED_APPS` setting:

    INSTALLED_APPS += ('icekit.page_types.layout_page', )

## Search Page Type

Integrates [Haystack] search into the hierarchical page tree.

Add to the `INSTALLED_APPS` setting:

    INSTALLED_APPS += ('icekit.page_types.search_page', )

## Adding Modular Content to Models

You can add modular content to any model, not only hierarchical `Page` models,
with two mixin classes:

    # models.py

    from icekit.abstract_models import FluentFieldsMixin

    class MyModel(FluentFieldsMixin, MyModelBase):
        ...

    # admin.py

    from icekit.admin import FluentLayoutsMixin

    class MyModelAdmin(FluentLayoutsMixin, MyModelAdminBase):
        ...

`FluentFieldsMixin` will add a `layout` field to your model, so you'll need a
migration for this change:

    $ ./manage.py makemigrations myapp
    $ ./manage.py migrate

TODO: Use `django-generic-m2m` to integrate our flexible layouts system with
any model, without requiring a migration.

## HTML Docs

Docs are written in [Markdown]. You can use [MkDocs] to preview your
documentation as you are writing it:

    (venv)$ mkdocs serve

It will even auto-reload whenever you save any changes, so all you need to do
to see your latest edits is refresh your browser.

[Changelog]: changelog.md
[Contributing]: contributing.md
[django-fluent-contents]: https://github.com/edoburu/django-fluent-contents
[django-fluent-pages]: https://github.com/edoburu/django-fluent-pages
[FluentContentsPage]: http://django-fluent-pages.readthedocs.org/en/latest/api/integration/fluent_contents.html?highlight=fluentcontentspage#the-fluentcontentspage-class
[Haystack]: http://haystacksearch.org/
[Interaction Consortium]: http://interaction.net.au
[Markdown]: http://daringfireball.net/projects/markdown/
[MkDocs]: http://mkdocs.org
