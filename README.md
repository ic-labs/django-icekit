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
