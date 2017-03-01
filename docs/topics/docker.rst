More about Docker
=================

ICEkit is Docker-compatible, and we recommend using Docker for development and
deployment. Docker has many advantages over a simple Python virtualenv
environment:

-  It eliminates the "works on my machine" problem by exactly reproducing
   an identical runtime environment everywhere.

-  It eliminates the need to install and run service dependencies directly
   on your OS, such as Elastic Search, PostgreSQL, Redis, etc.

-  It eliminates the need to install library dependencies directly on your
   OS, such as libjpeg, libtiff, etc.

-  It provides easy continuous deployment and rolling deployments on Docker
   Cloud via auto redeploy when a new image is built.

-  Much less (if any) downtime during deployments, because Node modules,
   Bower components and Python packages are already installed in the
   image.

Getting started
---------------

If you haven't already, install Docker:

-  `OS X <https://download.docker.com/mac/stable/Docker.dmg>`__
-  `Linux <https://docs.docker.com/engine/installation/linux/>`__
-  `Windows <https://download.docker.com/win/stable/InstallDocker.msi>`__

The typical Docker workflow is:

-  Define the image build instructions for each service with a
   ``Dockerfile``.

-  Configure and manage a collection of services with a
   ``docker-compose.yml`` file.

-  During local development, mount your source directory into containers
   for rapid iteration without having to rebuild images.

Useful Docker commands
----------------------

Here are some of the most commonly used Docker commands when getting
started::

    # Rebuild images for all services in your compose file
    $ docker-compose build --pull

    # Start all services in your compose file
    $ docker-compose up

    # Stop all services in your compose file
    $ docker-compose stop

    # List all containers for services in your compose file
    $ docker-compose ps

    # Open a new shell (`entrypoint.sh`) inside an already running container
    # for the `django` service
    $ docker-compose exec django entrypoint.sh

    # Remove all exited containers and their volumes
    docker rm -v $(docker ps -a -f status=exited -q)

    # Remove all dangling images (not tagged or used by any container)
    docker rmi $(docker images -f dangling=true -q)

    # Remove all dangling volumes (not used by any container)
    docker volume rm $(docker volume list -f dangling=true -q)

    # Remove ALL containers, images and volumes, to start from scratch
    docker rm -f $(docker ps -a -q)
    docker rmi $(docker images -q)
    docker volume rm $(docker volume ls -q)

Docker-cloud commands
---------------------

The following commands can be run on a terminal in ICEkit's Django
`docker cloud`_ container. First run ``entrypoint.sh bash`` to set up the
environment:

Debug server
~~~~~~~~~~~~

::

    # Run Django's debug server on a cloud container, for debugging
    $ supervisorctl.sh stop all
    $ runserver.sh
    # then when you've finished and Ctrl-C exited runserver
    $ supervisorctl.sh start all

Data dumps
~~~~~~~~~~

::

    # Dump a database, encrypt it, and upload to the transfer.sh service, then delete the local copy
    $ pg_dump -O -x -f ~/dump.sql && cat ~/dump.sql|gpg -ac -o-|curl -X PUT --upload-file "-" https://transfer.sh/dump.sql.gpg && rm ~/dump.sql

    # then on the destination machine, to download and decrypt:
    $ curl [transfer.sh url] | gpg -o- > dump.sql
    $ psql < dump.sql
    $ rm dump.sql

Uninstalling a GLAMkit/ICEkit project from Docker
-----------------------------=======-------------

Delete all containers with a name matching ``{project_name}``::

    $ docker rm $(docker ps -a -f "name={project_name}" -q)

To delete the associated images, run::

    $ docker images #list all images

and for each image you want to delete::

    $ docker rmi {image id}

If you are running other ICEkit projects, then you only need to delete
the image that starts with ``[project_name]`` - the other images will be
used by other projects. To remove all "dangling" images (untagged and
not referenced by a container)::

    $ docker rmi $(docker images -f "dangling=true" -q)

Finally, remove the project folder.
