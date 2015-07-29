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
