[![Build Status](https://img.shields.io/travis/ic-labs/django-icekit.svg)](https://travis-ci.org/ic-labs/django-icekit)
[![Coverage Status](https://img.shields.io/coveralls/ic-labs/django-icekit.svg)](https://coveralls.io/github/ic-labs/django-icekit)
[![Version](https://img.shields.io/pypi/v/django-icekit.svg)](https://pypi.python.org/pypi/django-icekit)

# Getting started

Create a new ICEkit project in the given directory (default: `icekit-project`):

    $ bash <(curl -L https://raw.githubusercontent.com/ic-labs/django-icekit/master/bin/startproject.sh) [destination_dir]

NOTE: Windows users should run this command in Git Bash, which comes with
[Git for Windows].

# Run with Docker

The easiest way to run an ICEkit project is with Docker. It works on OS X,
Linux, and Windows, and takes care of all the project dependencies like the
database and search engine.

Install Docker:

  * OS X: https://download.docker.com/mac/stable/Docker.dmg
  * Linux: https://docs.docker.com/engine/installation/linux/
  * Windows: https://download.docker.com/win/stable/InstallDocker.msi

Start the project from the project directory:

    $ docker-compose up

Now you can open the site:

    http://lvh.me

For an overview on how to use Docker with an ICEkit project, check out our
[Docker Quick Start] guide.

# Run directly

If you are not yet ready for Docker, you can run an ICEkit project directly.
You'll just need to install and configure all of its dependencies manually.

Install required system packages:

  * Elasticsearch
  * PostgreSQL
  * Python 2.7
  * Redis

Install required Python packages:

    $ pip install -r requirements.txt

Create a database and apply migrations:

    $ createdb icekit
    $ ./go.sh manage.py migrate

Start the project:

    $ ./go.sh manage.py supervisor

Now you can open the site:

    http://lvh.me:8000

[Docker Quick Start]: https://github.com/ic-labs/django-icekit/blob/master/docs/docker-quick-start.md
[Git for Windows]: https://git-for-windows.github.io/
