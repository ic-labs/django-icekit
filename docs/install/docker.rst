.. The following also appears in README. Keep synchronised.

Installing and running
~~~~~~~~~~~~~~~~~~~~~~

The recommended installation method uses Docker.
Docker works on OS X, Linux, and Windows, takes care of all the project
dependencies (e.g. database, search engine, web server, etc.), and makes
:doc:`../deploying/index` easy.

If you're not ready to use Docker, see `Manual Installation </install/manual-install>`_.

Otherwise, if you haven't already, `install Docker <https://docs.docker.com/engine/installation/>`_.

.. include:: /install/_new_project.rst

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
