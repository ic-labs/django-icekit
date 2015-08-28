# Overview

A modular content CMS by [Interaction Consortium].

## Table of Contents

  * [Changelog]
  * [Contributing]

## Installation

Install the app into your virtualenv:

    (venv)$ pip install -r requirements.txt -e git+ssh://git@github.com/ixc/django-icekit.git#egg=django-icekit[brightcove,dev,search,test]  # Omit unwanted optional extras.

Update your settings module:

    INSTALLED_APPS += ('icekit', )

## Usage

If you need a basic Page that supports our upgraded Layout system, just use LayoutPage.

Add the LayoutPage to your settings' Page Types definition:

    INSTALLED_APPS += (
        # Page types.
        # [...] existing page types
        'icekit.page_types.layout_page',
    )

Run the migrations for the page type:

    (venv)$ ./manage.py migrate

**Optional** You may wish to switch off the default Fluent Page as it uses the primitive file-based templates for layouts. Your Page Types config would therefore look something like:

    INSTALLED_APPS = (
        # [...]

        # Page types.
        # 'fluent_pages.pagetypes.flatpage',
        # 'fluent_pages.pagetypes.fluentpage',
        'fluent_pages.pagetypes.redirectnode',
        'icekit.page_types.layout_page',
    )

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

## Configuring Layouts

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

## HTML Docs

Docs are written in [Markdown]. You can use [MkDocs] to preview your
documentation as you are writing it:

    (venv)$ mkdocs serve

It will even auto-reload whenever you save any changes, so all you need to do
to see your latest edits is refresh your browser.

[Changelog]: changelog.md
[Contributing]: contributing.md
[Interaction Consortium]: http://interaction.net.au
[Markdown]: http://daringfireball.net/projects/markdown/
[MkDocs]: http://mkdocs.org
