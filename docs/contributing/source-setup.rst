Setting up a new project from source, with Docker
=================================================

You can run the included project template inside the repo, without first
creating a project from the template.

Get the code::

    $ git clone https://github.com/ic-labs/django-icekit.git
    $ cd django-icekit

Run a ``django`` container and all of its dependancies::

    $ docker-compose run --rm --service-ports django

Run the tests::

    bash$ runtests.sh

Create a superuser account::

    bash$ manage.py createsuperuser

Run the Django dev server::

    bash$ runserver.sh

Open the site in a browser::

    http://localhost:8000

When you're done, exit the container and stop all of its dependencies::

    bash$ exit
    $ docker-compose stop

Running multiple containers
---------------------------

Only one container can bind a fixed service port on the host at a time.

If you want to run a second container, for example to run tests in while
running the Django dev server, you will need to run it with a different
fixed port or a dynamic port::

    $ docker-compose run --rm -p 8001:8000 django  # fixed: 8001->8000
    $ docker-compose run --rm -p 8000 django  # dynamic, check with docker-compose ps

Run without Docker
------------------

If you don't want to use Docker, read :doc:`../install/manual-install`.
