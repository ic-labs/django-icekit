# Overview

A modular content CMS by [Interaction Consortium], built on top of
[django-fluent-pages] and [django-fluent-contents].

Includes the following features:

  * Flexible layouts system.
      * Define modular content placeholders in layout templates.
      * Enable different layouts for different models.
      * Switch layouts at the instance level.
  * Page type plugins:
      * `article_page` - integrates with Fluent Pages.
      * `layout_page` - integrates with our flexible layouts system.
      * `search_page` - integrates with [Haystack].
  * Modular content plugins:
      * `brightcove`
      * `child_pages`
      * `faq`
      * `file`
      * `horizontal_rule`
      * `image`
      * `instagram_embed`
      * `map`
      * `map_with_text`
      * `oembed_with_caption`
      * `page_anchor`
      * `page_anchor_list`
      * `quote`
      * `reusable_form`
      * `slideshow`
      * `text`
      * `twitter_embed`

## Table of Contents

  * [Changelog]
  * [Contributing]

## Installation

Create a new ICEkit project from our project template:

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/develop/icekit/bin/startproject.sh) [destination_dir]

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

## Article Page Type

The article page type is designed to be used with `fluent_pages`.

Add to the `INSTALLED_APPS` setting:

    INSTALLED_APPS += ('icekit.page_types.article', )

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

[Changelog]: changelog.md
[Contributing]: contributing.md
[django-fluent-contents]: https://github.com/edoburu/django-fluent-contents
[django-fluent-pages]: https://github.com/edoburu/django-fluent-pages
[FluentContentsPage]: http://django-fluent-pages.readthedocs.org/en/latest/api/integration/fluent_contents.html?highlight=fluentcontentspage#the-fluentcontentspage-class
[Haystack]: http://haystacksearch.org/
[Interaction Consortium]: http://interaction.net.au
