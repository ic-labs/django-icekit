[![Build Status](https://img.shields.io/travis/ic-labs/django-icekit.svg)](https://travis-ci.org/ic-labs/django-icekit)
[![Documentation](https://readthedocs.org/projects/icekit/badge/)](https://icekit.readthedocs.io/)
[![Coverage Status](https://img.shields.io/coveralls/ic-labs/django-icekit.svg)](https://coveralls.io/github/ic-labs/django-icekit)
[![Version](https://img.shields.io/pypi/v/django-icekit.svg)](https://pypi.python.org/pypi/django-icekit)

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/)

ICEkit is a next-generation CMS by [the Interaction Consortium], built on top of
[django-fluent-pages] and [django-fluent-contents]. See [ICEkit features at a
glance](docs/intro/features.md)

ICEkit underpins [GLAMkit](http://glamkit.org) and many individual sites.

# Quickstart
<!-- keep identical with docs/intro/install.md, except for link relativity. -->

For detailed instructions, see [Manual Setup](docs/intro/manual-setup.md).

## 1. Start a new project

With [Docker installed and running](docs/intro/docker.md),
create a new project template with:

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) <project_name>

This script will create a new project in a directory named <project_name> in
the current working directory, ready to hack on. NOTE: Windows users should
run this command in Git Bash, which comes with
[Git for Windows](https://git-for-windows.github.io/).


## 2. Run the project

    $ cd <project_name>
    $ docker-compose build --pull
    $ docker-compose up

This will ensure all dependencies are installed and up to date, and will run
a development server. <strong>Watch for the admin account credentials that get created on first run</strong>.</p>

It will take a few minutes the first time. When you see the following message, you will know it is ready:

    #
    # READY.
    #

## 3. That's it!

Open your new GLAMkit site in a browser:

    http://<project_name>.lvh.me:8000

(`*.lvh.me` is a wildcard DNS that maps to 127.0.0.1)

# Next steps

* Read the [overview of ICEkit architecture](docs/intro/architecture.md)
* [Start building your site](docs/howto/start.md)
* Read the [Documentation](http://icekit.readthedocs.io) on Read the Docs

<!-- editors guide -->

[django-fluent-contents]: https://github.com/edoburu/django-fluent-contents
[django-fluent-pages]: https://github.com/edoburu/django-fluent-pages
[the Interaction Consortium]: http://interaction.net.au
