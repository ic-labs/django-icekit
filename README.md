[![Build Status](https://img.shields.io/travis/ic-labs/django-icekit.svg)](https://travis-ci.org/ic-labs/django-icekit)
[![Coverage Status](https://img.shields.io/coveralls/ic-labs/django-icekit.svg)](https://coveralls.io/github/ic-labs/django-icekit)
[![Version](https://img.shields.io/pypi/v/django-icekit.svg)](https://pypi.python.org/pypi/django-icekit)

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/)

# Getting started

Create a new ICEkit project in the given directory (default: `icekit-project`):

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/develop/icekit/bin/startproject.sh) [destination_dir]

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
    $ docker-compose up  # Watch for the admin account credentials that get created on first run

Now you can open the site in a browser:

    http://icekit.lvh.me  # *.lvh.me is a wildcard DNS that maps to 127.0.0.1

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
    (venv)$ pip install -r requirements-icekit.txt

Start the project:

    (venv)$ ./go.sh manage.py supervisor  # Watch for the admin account credentials that get created on first run

Now you can open the site in a browser:

    http://icekit.lvh.me:8000  # *.lvh.me is a wildcard DNS that maps to 127.0.0.1

# Deploy to Docker Cloud

Use the Deploy to Docker Cloud button above to create a new ICEkit stack on
[Docker Cloud](https://cloud.docker.com/).

You won't be able to [customise your project](#customise-your-project) when
deploying the official ICEkit Docker image this way.

# Configure your project

You will need to provide some basic information to configure your project.

You can do so with environment variables, or by editing the `docker-cloud.yml`
and `icekit_settings.py` files.

All settings are optional, but you can provide:

  * `BASE_SETTINGS_MODULE` tells ICEkit to run in `develop` or `production`
    mode.

  * `EMAIL_HOST`, `EMAIL_HOST_PASSWORD` and `EMAIL_HOST_USER`, so ICEkit can
    send emails (only in `production` mode).

    We recommend [Mailgun](http://www.mailgun.com/), but any SMTP credentials
    will do.

  * `MASTER_PASSWORD` (only in `develop` mode) so you can login as any user
    with the same password.

  * `MEDIA_AWS_ACCESS_KEY_ID`, `MEDIA_AWS_SECRET_ACCESS_KEY` and
    `MEDIA_AWS_STORAGE_BUCKET_NAME` so ICEkit can store file uploads
    [Amazon S3](https://aws.amazon.com/s3/).

    The specified bucket should already exist, or the credentials provided
    should have permission to create buckets. This is especially important when
    deploying to ephemeral infrastructure, like Docker Cloud.

  * `PGDATABASE`, `PGHOST`, `PGPASSWORD`, `PGPORT` and `PGUSER`, if you need to
    connect to provide credentials for your PostgreSQL database.

    We recommend [Amazon RDS](https://aws.amazon.com/rds/), especially when
    deploying to ephemeral infrastructure, like Docker Cloud.

  * `SENTRY_DSN`, if you want to use [Sentry](https://getsentry.com/) for
    real-time error tracking.

  * `SITE_DOMAIN` and `SITE_NAME`, so ICEkit knows how to generate redirects
    correctly and knows what to call your site.

# Customise your project

Anything you put in the `static` or `templates` directory will override the
default ICEkit static files and templates.

You can specify additional Bower components in `bower.json`, Node modules in
`package.json`, and Python packages in `requirements.txt`.

The `icekit_settings.py` file is a Django settings module. You can override any
default ICEkit settings or configure apps installed via `requirements.txt`.
