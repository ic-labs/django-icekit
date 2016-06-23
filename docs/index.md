# Overview

TODO

## Table of Contents

  * [Changelog]
  * [Contributing]

## Installation

Install the app into your virtualenv:

    (venv)$ pip install -e git+ssh://git@github.com/ixc/<app_name>.git#egg=<app_name>

Update your settings module:

    INSTALLED_APPS += ('eventkit', )

Install Bower dependencies manually:

    (venv)$ cd venv/src/glamkit-eventkit-plus/eventkit/static/eventkit
    (venv)$ bower install

## Usage

TODO

## HTML Docs

Docs are written in [Markdown]. You can use [MkDocs] to preview your
documentation as you are writing it:

    (venv)$ mkdocs serve

It will even auto-reload whenever you save any changes, so all you need to do
to see your latest edits is refresh your browser.

[Changelog]: changelog.md
[Contributing]: contributing.md
[Markdown]: http://daringfireball.net/projects/markdown/
[MkDocs]: http://mkdocs.org
