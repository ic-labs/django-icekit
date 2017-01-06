|Build Status| |Coverage Status| |Documentation| |Requirements Status|
|Version|

|Deploy to Docker Cloud|

ICEkit is a next-generation CMS by `the Interaction
Consortium <http://interaction.net.au>`__, built on top of
`django-fluent-pages <https://github.com/edoburu/django-fluent-pages>`__
and
`django-fluent-contents <https://github.com/edoburu/django-fluent-contents>`__.
See `ICEkit features at a glance <docs/intro/features.md>`__.

ICEkit underpins `GLAMkit <http://glamkit.org>`__ and many individual
sites.

Quickstart, with Docker
=======================

If you haven't already, install `Docker <docs/intro/docker.md>`__:

-  `OS X <https://download.docker.com/mac/stable/Docker.dmg>`__
-  `Linux <https://docs.docker.com/engine/installation/linux/>`__
-  `Windows <https://download.docker.com/win/stable/InstallDocker.msi>`__

Docker works on OS X, Linux, and Windows, takes care of all the project
dependencies (e.g. database, search engine, web server, etc.), and makes
`deployment <docs/howto/deployment.md>`__ easy.

If you're not ready for Docker, see `Manual
Setup <docs/intro/manual-setup.md>`__.

1. Create a new project
-----------------------

::

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) {project_name}

This will create a new project from the ICEkit project template, in a
directory named ``{project_name}`` in the current working directory.

NOTE: Windows users should run this command in Git Bash, which comes
with `Git for Windows <https://git-for-windows.github.io/>`__.

2. Run the project
------------------

Build a Docker image:

::

    $ cd {project_name}
    $ docker-compose build --pull

Run a ``django`` container and all of its dependancies:

::

    $ docker-compose run --rm --service-ports django

Create a superuser account:

::

    # manage.py createsuperuser

Run the Django dev server:

::

    # runserver.sh

3. That's it!
-------------

Open the site in a browser:

::

    http://localhost:8000

When you're done, exit the container and stop all of its dependencies:

::

    # exit
    $ docker-compose stop

Next steps
==========

-  `Start building your site <docs/howto/start.md>`__
-  `Architectural overview <docs/intro/architecture.md>`__
-  `Read the Documentation <http://icekit.readthedocs.io>`__

.. |Build Status| image:: https://img.shields.io/travis/ic-labs/django-icekit.svg
   :target: https://travis-ci.org/ic-labs/django-icekit
.. |Coverage Status| image:: https://img.shields.io/coveralls/ic-labs/django-icekit.svg
   :target: https://coveralls.io/github/ic-labs/django-icekit
.. |Documentation| image:: https://readthedocs.org/projects/icekit/badge/
   :target: https://icekit.readthedocs.io/
.. |Requirements Status| image:: https://img.shields.io/requires/github/ic-labs/django-icekit.svg
   :target: https://requires.io/github/ic-labs/django-icekit/requirements/
.. |Version| image:: https://img.shields.io/pypi/v/django-icekit.svg
   :target: https://pypi.python.org/pypi/django-icekit
.. |Deploy to Docker Cloud| image:: https://files.cloud.docker.com/images/deploy-to-dockercloud.svg
   :target: https://cloud.docker.com/stack/deploy/?repo=https://github.com/ic-labs/django-icekit/
