Installing and running ICEkit using Docker (recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you haven't already, install Docker (see :doc:`../topics/docker`):

-  `OS X <https://download.docker.com/mac/stable/Docker.dmg>`__
-  `Linux <https://docs.docker.com/engine/installation/linux/>`__
-  `Windows <https://download.docker.com/win/stable/InstallDocker.msi>`__

Docker works on OS X, Linux, and Windows, takes care of all the project
dependencies (e.g. database, search engine, web server, etc.), and makes
:doc:`../deploying/index` easy.

If you're not ready for Docker, see :doc:`install-manual`.

1. Create a new project
^^^^^^^^^^^^^^^^^^^^^^^

::

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) {project_name}

This will create a new project from the ICEkit project template, in a
directory named ``{project_name}`` in the current working directory.

NOTE: Windows users should run this command in Git Bash, which comes
with `Git for Windows <https://git-for-windows.github.io/>`__.

2. Run the project
^^^^^^^^^^^^^^^^^^

Build a Docker image::

    $ cd {project_name}
    $ docker-compose build --pull

Run a ``django`` container and all of its dependencies::

    $ docker-compose run --rm --service-ports django

This will give you a shell inside the Docker container. Create a superuser account::

    bash$ manage.py createsuperuser

Run the Django dev server::

    bash$ runserver.sh

3. That's it!
^^^^^^^^^^^^^

Open the site in a browser::

    http://{ my_project }.lvh.me:8000

When you're done, exit the container and stop all of its dependencies::

    bash$ exit
    $ docker-compose stop
