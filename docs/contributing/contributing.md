# Contributing

Please follow these guidelines when making contributions to this project.

## Getting Started

Get the code:

    $ git clone https://github.com/ic-labs/django-icekit.git
    $ cd django-icekit

Run the tests:

    $ docker-compose -f docker-compose.travis.yml run --rm django

Build an ICEkit image and start the project:

    $ docker-compose build --pull
    $ docker-compose up

Run the tests without Docker:

    $ cd project_template
    $ ./go.sh entrypoint.sh collectstatic
    $ ./go.sh runtests.sh

Start the project template without Docker:

    $ ./go.sh
    $ supervisord.sh

## Git

We are using the [Gitflow] branching model. Basically:

  * The `master` branch contains stable code, and each commit represents a
    tagged release.
  * The `develop` branch is an integration branch for new features, and is
    merged into `master` when we are ready to tag a new release.
  * New features are developed in `feature/*` branches. Create a pull request
    when you are ready to merge a feature branch back into `develop`.

The [SourceTree] app (OS X and Windows) has built-in support for Gitflow, and
there is also a collection of [git-extensions] for command line users.

## Code Style

It's important that we adopt a consistent code style to minimise code churn and
make collaboration easier.

  * Follow [PEP8] for Python code, unless there is a good reason not to.
  * Install the [EditorConfig] plugin for your preferred code editor.

## Documentation

Docs are probably more important than tests!

  * Write [Markdown] docs for all notable changes and additions.
  * Include examples so new contributors can get started quickly.
  * Include rationale when there are competing solutions, so people know why
    they should use our solution.
  * Keep the [changelog] up to date. Use plain language to describe changes,
    as it may be read by people who are not familiar with the project or a
    particular feature.
  * Document all functions that don't begin with an underscore.

### HTML Docs

You can use [MkDocs] to preview your documentation as you are writing it:

    $ mkdocs serve

It will even auto-reload whenever you save any changes, so all you need to do
to see your latest edits is refresh your browser.

## Tests

We don't need 100% test coverage, but we should at least have:

  * Unit tests for all regression bugs.
  * Unit or integration tests for complex, fragile, or important functionality.

## Releases

  * When the changelog for a release gets sufficiently long or major features
    or fixes are implemented, tag a release.

[changelog]: changelog.md
[EditorConfig]: http://editorconfig.org/
[git-extensions]: https://github.com/nvie/gitflow/
[Gitflow]: http://nvie.com/posts/a-successful-git-branching-model/
[Markdown]: http://daringfireball.net/projects/markdown/
[MkDocs]: http://mkdocs.org
[PEP8]: http://legacy.python.org/dev/peps/pep-0008/
[SourceTree]: http://sourcetreeapp.com/
