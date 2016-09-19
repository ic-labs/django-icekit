# Installing ICEkit
<!-- keep identical with README -->

If you haven't already, install [Docker](docker.md):

  * [OS X](https://download.docker.com/mac/stable/Docker.dmg)
  * [Linux](https://docs.docker.com/engine/installation/linux/)
  * [Windows](https://download.docker.com/win/stable/InstallDocker.msi)

Docker works on OS X, Linux, and Windows, takes care of all the project
dependencies (e.g. database, search engine, web server, etc.), and makes
[deployment](../howto/deployment.md) easy.

If you're not ready for Docker, see [Manual Setup](manual-setup.md).

## 1. Create a new project

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) <project_name>

This will create a new project from the ICEkit project template, in a directory
named <project_name> in the current working directory.

NOTE: Windows users should run this command in Git Bash, which comes with
[Git for Windows](https://git-for-windows.github.io/).

## 2. Run the project

Build a Docker image:

    $ cd <project_name>
    $ docker-compose build --pull

Create a superuser account:

    $ docker-compose run --rm django manage.py createsuperuser

Run the project:

    $ docker-compose run --rm --service-ports django

## 3. That's it!

Open your new site in a browser:

    http://localhost:8000

# Next steps

  * [Start building your site](../howto/start.md)
  * [Features at a glance](features.md)
  * [Architectural overview](architecture.md)
