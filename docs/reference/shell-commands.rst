Useful shell commands
=====================

This document describes a few useful shell commands. For Docker
commands, see :doc:`../topics/docker`.

Opening a shell
---------------

Using Docker
~~~~~~~~~~~~

Open a shell on an already running container (e.g. via
``docker-compose up``)::

    $ docker-compose exec django entrypoint.sh

Or open a shell on a new container, and remove it on exit::

    $ docker-compose run --rm django

Without Docker
~~~~~~~~~~~~~~

Or open a shell without Docker from the ICEkit project template (or an
ICEkit project) directory::

    $ cd project_template
    $ ./go.sh

you can get a shell and skip the Django operations with::

    $ ./go.sh bash

Once in a shell
---------------

Run Django management commands::

    $ manage.py migrate --list
    $ manage.py shell_plus

Install a Python package::

    $ pip install -U django-icekit
    $ pip install -e git+https://github.com/ic-labs/django-icekit.git

Open a PostgreSQL shell::

    $ psql

Dump the database::

    $ pg_dump -O -x -f dump.sql

Run the tests::

    $ runtests.sh

Run a single test::

    $ runtests.sh path.to:TestCase.test_method

Manage Supervisord programs (Gunicorn, Nginx, etc.)::

    $ supervisorctl.sh status
    $ supervisorctl.sh restart gunicorn

Display a list of other frequently used shell commands::

    $ help.sh

