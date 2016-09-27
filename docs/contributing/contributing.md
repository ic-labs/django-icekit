# Contributing

Please follow these guidelines when making contributions.

# Run from source, with Docker

You can run the ICEkit project template as-is, without first creating a project
from the template.

Get the code:

    $ git clone https://github.com/ic-labs/django-icekit.git
    $ cd django-icekit

Run a `django` container and all of its dependancies:

    $ docker-compose run --rm --service-ports django

Run the tests:

    # runtests.sh

Create a superuser account:

    # manage.py createsuperuser

Run the Django dev server:

    # runserver.sh

Open the site in a browser:

    http://localhost:8000

When you're done, exit the container and stop all of its dependencies:

    # exit
    $ docker-compose stop

## Running multiple containers

Only one container can bind a fixed service port on the host at a time.

If you want to run a second container, for example to run tests in while
running the Django dev server, you will need to run it with a different fixed
port or a dynamic port:

    $ docker-compose run --rm -p 8001:8000 django  # fixed: 8001->8000
    $ docker-compose run --rm -p 8000 django  # dynamic, check with docker-compose ps

# Run without Docker

Read [Manual Setup](../intro/manual-setup.md) for more info on running an
ICEkit project without Docker.

# Installing the ICEkit dev version on an existing project

    $ docker-compose exec django entrypoint.sh
    $ pip install -e git+https://github.com/ic-labs/django-icekit.git#egg=django-icekit


# Git branching

We are using the [Gitflow] branching model. Basically:

  * The `master` branch contains stable code, and each commit represents a
    tagged release.
  * The `develop` branch is an integration branch for new features, and is
    merged into `master` when we are ready to tag a new release.
  * New features are developed in `feature/*` branches. Create a pull request
    when you are ready to merge a feature branch back into `develop`.

The [SourceTree] app (OS X and Windows) has built-in support for Gitflow, and
there is also a collection of [git-extensions](https://github.com/nvie/gitflow/)
for command line users.

# Code style

It's important that we adopt a consistent code style to minimise code churn and
make collaboration easier.

  * Follow [PEP8] for Python code, unless there is a good reason not to.
  * Install the [EditorConfig](http://editorconfig.org/) plugin for your
    preferred code editor.

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

[changelog]: ../changelog.md
[Gitflow]: http://nvie.com/posts/a-successful-git-branching-model/
[Markdown]: http://daringfireball.net/projects/markdown/
[PEP8]: http://legacy.python.org/dev/peps/pep-0008/
[SourceTree]: http://sourcetreeapp.com/
