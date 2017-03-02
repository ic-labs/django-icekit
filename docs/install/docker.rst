.. The following also appears in README. Keep synchronised.

Installing and running
~~~~~~~~~~~~~~~~~~~~~~

.. TODO: make the default install GLAMkit, with a variation for ICEkit.

The recommended technique uses Docker. For a manual installation, if you're not
ready to use Docker, see :doc:`/install/manual-install`.

If you haven't already, install Docker (see :doc:`../topics/docker` for
background information about why we use Docker, and some useful recipes):

-  `OS X <https://download.docker.com/mac/stable/Docker.dmg>`__
-  `Linux <https://docs.docker.com/engine/installation/linux/>`__
-  `Windows <https://download.docker.com/win/stable/InstallDocker.msi>`__

Docker works on OS X, Linux, and Windows, takes care of all the project
dependencies (e.g. database, search engine, web server, etc.), and makes
:doc:`../deploying/index` easy.

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
