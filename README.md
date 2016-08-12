[![Build Status](https://img.shields.io/travis/ic-labs/django-icekit.svg)](https://travis-ci.org/ic-labs/django-icekit)
[![Coverage Status](https://img.shields.io/coveralls/ic-labs/django-icekit.svg)](https://coveralls.io/github/ic-labs/django-icekit)
[![Version](https://img.shields.io/pypi/v/django-icekit.svg)](https://pypi.python.org/pypi/django-icekit)

# Getting started

Create a new ICEkit project in the given directory (default: `icekit-project`):

    $ bash <(curl -L https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/bin/startproject.sh) [destination_dir]

All other commands in this document should be run from the project directory.

NOTE: Windows users should run this command in Git Bash, which comes with
[Git for Windows](https://git-for-windows.github.io/).

# Run with Docker

The easiest way to run an ICEkit project is with Docker. It works on OS X,
Linux, and Windows, takes care of all the project dependencies like the
database and search engine, and makes deployment easy.

If you haven't already, go install Docker:

  * [OS X](https://download.docker.com/mac/stable/Docker.dmg)
  * [Linux](https://docs.docker.com/engine/installation/linux/)
  * [Windows](https://download.docker.com/win/stable/InstallDocker.msi)

Build an image and start the project:

    $ docker-compose build
    $ docker-compose up

Start the project:

    $ docker-compose up

Now you can open the site:

    http://lvh.me

Read our [Docker Quick Start](https://github.com/ic-labs/django-icekit/blob/master/docs/docker-quick-start.md)
guide for more info on using Docker with an ICEkit project.

# Run directly

If you are not yet ready for Docker, you can run an ICEkit project directly.
You will just need to install and configure all of its dependencies manually.

Install required system packages:

  * Elasticsearch
  * PostgreSQL
  * Python 2.7
  * Redis

On OS X, you can use [Homebrew](http://brew.sh/):

    $ brew install elasticsearch python redis

You don't need to configure these services to start automatically, they will
be started by the project.

We recommend [Postgres.app](http://postgresapp.com/) for the database. It is
easier to start, stop, and upgrade than Homebrew.

Make a virtualenv and install required Python packages:

    $ pip install virtualenv
    $ virtualenv venv
    (venv)$ pip install -r requirements.txt

Create a database and apply migrations:

    (venv)$ createdb icekit
    (venv)$ ./manage.py migrate

Start the project:

    (venv)$ ./manage.py supervisor

Now you can open the site:

    http://lvh.me:8000
