# Contributing

Please follow these guidelines when making contributions.

# Getting started

You can run the ICEkit project template as-is, without first creating a project
from the template.

Get the code:

    $ git clone https://github.com/ic-labs/django-icekit.git
    $ cd django-icekit

Build a Docker image:

    $ docker-compose build --pull

Start all services:

    $ docker-compose up

This will take a few minutes. You will know it is ready when you see:

    #
    # READY.
    #

Now you can open the site in a browser:

    http://localhost:8000

Create a superuser account:

    $ docker-compose exec django entrypoint.sh manage.py createsuperuser

Stop all services:

    $ docker-compose stop

Run the tests:

    $ docker-compose run --rm django entrypoint.sh runtests.sh

# Run without Docker

Read [Manual Setup](../intro/manual-setup.md) for more info on running an
ICEkit project without Docker.

# Git

We are using the [Gitflow] branching model. Basically:

  * The `master` branch contains stable code, and each commit represents a
    tagged release.
  * The `develop` branch is an integration branch for new features, and is
    merged into `master` when we are ready to tag a new release.
  * New features are developed in `feature/*` branches. Create a pull request
    when you are ready to merge a feature branch back into `develop`.

The [SourceTree] app (OS X and Windows) has built-in support for Gitflow, and
there is also a collection of [git-extensions] for command line users.

# Code style

It's important that we adopt a consistent code style to minimise code churn and
make collaboration easier.

  * Follow [PEP8] for Python code, unless there is a good reason not to.
  * Install the [EditorConfig] plugin for your preferred code editor.

# Tests

We don't strictly need 100% test coverage, but we aim to have:

  * Unit tests for all regression bugs.
  * Unit or integration tests for complex, fragile, or important functionality.

# Documentation

Docs are just as important as tests.

  * Write [Markdown] docs for all notable changes and additions.
  * Include examples so new contributors can get started quickly.
  * Keep the [changelog] up to date. Describe features, not implementation
    details, except for backwards incompatible changes.

# Releases

When the [changelog] for a release gets sufficiently long or major features or
fixes are implemented, tag and upload a release to PyPI.

[changelog]: changelog.md
[EditorConfig]: http://editorconfig.org/
[git-extensions]: https://github.com/nvie/gitflow/
[Gitflow]: http://nvie.com/posts/a-successful-git-branching-model/
[Markdown]: http://daringfireball.net/projects/markdown/
[MkDocs]: http://mkdocs.org
[PEP8]: http://legacy.python.org/dev/peps/pep-0008/
[SourceTree]: http://sourcetreeapp.com/
