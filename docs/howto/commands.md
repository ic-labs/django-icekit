# Useful commands

This document contains some commands for achieving common tasks. These
commands assume you are running ICEkit in a Docker container.

For common Docker commands, see the [Docker docs](../intro/docker.md).

## Shell commands

To get to a django shell (we prefer the enhanced shell which imports all the
models and has tab completion):

    $ docker-compose exec django entrypoint.sh
    # manage.py shell_plus

To run tests:

    $ docker-compose exec django entrypoint.sh
    # manage.py test

<!-- or without migrations: -->

## Suggestions?

If you'd like to add a useful command, please
[create a ticket](https://github.com/ic-labs/django-icekit/issues/new) and/or
submit a pull request.
