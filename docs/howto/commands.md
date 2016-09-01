# Useful shell commands

This document describes a few useful shell commands. For Docker commands, see
our [Docker intro](../intro/docker.md).

## Opening a shell

Open a shell on an already running container (e.g. via `docker-compose up`):

    $ docker-compose exec django entrypoint.sh

Or open a shell on a new container, and remove it on exit:

    $ docker-compose run --rm django entrypoint.sh

Or open a shell without Docker from the ICEkit project template (or an ICEkit
project) directory:

    $ cd project_template
    $ ./go.sh

## Once in a shell

Run Django management commands:

    $ manage.py migrate --list
    $ manage.py shell_plus

Install a Python package:

    $ pip install -U django-icekit
    $ pip install -e git+https://github.com/ic-labs/django-icekit.git

Open a PostgreSQL shell:

    $ psql

Dump the database:

    $ pg_dump -O -x -f dump.sql

Run the tests:

    $ runtests.sh

Run a single test:

    $ runtests.sh path.to:TestCase.test_method

Manage Supervisord programs (Gunicorn, Nginx, etc.):

    $ supervisorctl.sh status
    $ supervisorctl.sh restart gunicorn

Display a list of other frequently used shell commands:

    $ help.sh

## Uninstalling an ICEkit project

Delete all containers with a name matching `<project_name>`:

    $ docker rm $(docker ps -a -f "name=<project_name>" -q)

To delete the associated images, run:

    $ docker images #list all images

and for each image you want to delete:

    $ docker rmi <image id>

If you are running other ICEkit projects, then you only need to delete the
image that starts with `[project_name]` - the other images will be used by
other projects. To remove all "dangling" images (untagged and not referenced by
a container):

    $ docker rmi $(docker images -f "dangling=true" -q)

Finally, remove the project folder.

## Suggestions?

If you'd like to add a useful command, please
[create a ticket](https://github.com/ic-labs/django-icekit/issues/new) and/or
submit a pull request.
