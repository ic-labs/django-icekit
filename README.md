# Readme

Docs can be found in the [docs](docs/index.md) folder.

# Quick Start

Start a new project:

    $ curl -L http://bit.ly/django-icekit-template | bash -s {project_name}

# Run with Docker

If you have installed [Docker Toolbox][docker-toolbox] (OS X, Windows) or
[Docker Engine][docker-engine] and [Docker Compose][docker-compose] (Linux),
you can run your project and all its required services with a single command:

    $ docker-compose up

Running with docker has a few more advantages beyond making it easier to get
started, not having to install service dependencies at system level, and run
with a more consistent environment across developers:

  * Automatically update Node.js packages, Bower components, and Python
    virtualenv when `package.json`, `bower.json`, `requirements*.txt` or
    `setup.py` are changed.

  * Automatically create a database named from your current git branch, and
    restore a seed database (if `var/initial_data.sql` exists) into it. So you
    can switch to feature branches and test against a recent database dump,
    without breaking your current database.

# Docker Cheat Sheet

Here are the basics when getting started with Docker:

    # Rebuild the project image
    $ docker-compose build --pull

    # Start all project services, building if no image is already available
    $ docker-compose up

    # Stop all project services
    $ docker-compose stop

    # List all project container names and their status
    $ docker-compose ps -a

    # Open a new shell inside a running container, using the same entrypoint
    $ docker exec -it {container-name} entrypoint.sh bash

    # Remove all stopped containers and their data volumes
    docker rm -v $(docker ps -a -q -f status=exited)

    # Remove all "dangling" images (untagged and not referenced by a container)
    docker rmi $(docker images -f "dangling=true" -q)

# Run without Docker

If you're not using Docker, you will need to install the required services and
library dependencies manually.

On OS X, you can do use Homebrew:

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ brew bundle

Depending on how you install the required services, you might need to
reconfigure them in `djangosite/settings/local.py`.

Create a database and Python virtualenv:

    $ createdb {project_name}
    $ pip install virtualenvwrapper
    $ mkvirtualenv -a $PWD {project_name}
    $ pip install -e .

Apply database migrations and run the project:

    $ ./manage.py migrate
    $ ./manage.py runserver

[Docker Compose]:https://docs.docker.com/compose/install/
[Docker Engine]: https://docs.docker.com/engine/installation/
[Docker Toolbox]: https://www.docker.com/products/docker-toolbox
