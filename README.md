[![Build Status](https://img.shields.io/travis/ic-labs/django-icekit.svg)](https://travis-ci.org/ic-labs/django-icekit)
[![Coverage Status](https://img.shields.io/coveralls/ic-labs/django-icekit.svg)](https://coveralls.io/github/ic-labs/django-icekit)
[![Documentation](https://readthedocs.org/projects/icekit/badge/)](https://icekit.readthedocs.io/)
[![Version](https://img.shields.io/pypi/v/django-icekit.svg)](https://pypi.python.org/pypi/django-icekit)

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/)

ICEkit is a next-generation CMS by [the Interaction Consortium], built on top
of [django-fluent-pages] and [django-fluent-contents]. See
[ICEkit features at a glance](docs/intro/features.md).

ICEkit underpins [GLAMkit](http://glamkit.org) and many individual sites.

# Quickstart, with Docker
<!-- keep identical with docs/intro/install.md, except for link relativity. -->

If you haven't already, install [Docker](docs/intro/docker.md):

  * [OS X](https://download.docker.com/mac/stable/Docker.dmg)
  * [Linux](https://docs.docker.com/engine/installation/linux/)
  * [Windows](https://download.docker.com/win/stable/InstallDocker.msi)

Docker works on OS X, Linux, and Windows, takes care of all the project
dependencies (e.g. database, search engine, web server, etc.), and makes
[deployment](docs/howto/deployment.md) easy.

If you're not ready for Docker, see [Manual Setup](docs/intro/manual-setup.md).

## 1. Create a new project

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) <project_name>

This will create a new project from the ICEkit project template, in a directory
named <project_name> in the current working directory.

NOTE: Windows users should run this command in Git Bash, which comes with
[Git for Windows](https://git-for-windows.github.io/).

## 2. Run the project

    $ cd <project_name>
    $ docker-compose build --pull
    $ docker-compose run --rm --service-ports django

This will build a Docker image, download and install all dependencies, and
start all required services.

It will take a few minutes the first time. When you see the following message,
you will know it is ready:

    #
    # READY.
    #

Create a superuser account:

    $ docker-compose run --rm django entrypoint.sh manage.py createsuperuser

## 3. That's it!

Open your new site in a browser:

    http://localhost:8000

# Next steps

  * [Start building your site](docs/howto/start.md)
  * [Architectural overview](docs/intro/architecture.md)
  * [Read the Documentation](http://icekit.readthedocs.io)

<!-- editors guide -->

[django-fluent-contents]: https://github.com/edoburu/django-fluent-contents
[django-fluent-pages]: https://github.com/edoburu/django-fluent-pages
[the Interaction Consortium]: http://interaction.net.au
