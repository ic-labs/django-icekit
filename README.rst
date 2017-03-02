|Build Status| |Coverage Status| |Documentation| |Requirements Status|
|Version|

|Deploy to Docker Cloud|

.. The following is taken from docs/includes/intro.rst. Keep synchronised.

GLAMkit is a next-generation Python CMS by `the Interaction
Consortium <http://interaction.net.au>`__, designed especially for
the cultural sector.

ICEkit sits one layer below GLAMkit, and is a framework for building CMSes.
It has publishing and workflow tools for teams of content professionals,
and a powerful content framework, based on django-fluent. Everything is written
in Python, using the Django framework.

`Read the documentation for the latest release <http://icekit.readthedocs.io>`_

Key features
============

ICEkit has:

-  Patterns for hierarchical pages and collections of rich content models.
-  Advanced publishing / preview / unpublishing controls
-  Simple workflow controls
-  Content plugins for working with rich text, images, embedded media, etc.
-  Customisable site search using Elastic Search
-  ``django-reversion`` compatible, allowing versioning of content
-  Customisable admin dashboard
-  Docker-compatible project template supplied
-  Batteries included: bower, LessCSS, Bootstrap
-  Easily extensible with models, templates, plugins, etc.

GLAMkit extends ICEkit with:

-  complex repeating calendared events
-  collection patterns: art, moving image, etc.
-  a story-telling engine (e.g. rich 'watch', 'read', 'listen' articles)
-  press releases
-  sponsors

GLAMkit is delivered as a Docker-compatible package, which means that it's easy
to share a consistent development environment across your team, or to deploy on
any Docker-compatible web host, including top-tier cloud hosting services like
AWS.

.. The following is taken from install/docker.rst. Keep synchronised.

Quickstart, with Docker
=======================

The recommended installation method uses Docker.
Docker works on OS X, Linux, and Windows, takes care of all the project
dependencies (e.g. database, search engine, web server, etc.), and makes
`deployment <docs/howto/deployment.md>`__ easy.

If you're not ready to use Docker, see `Manual Installation <docs/install/manual-install.rst>`_.

Otherwise, if you haven't already, `install Docker <https://docs.docker.com/engine/installation/>`_.

1. Create a new project
-----------------------

::

   $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) {project_name}

This will create a new project from the ICEkit project template, in a
directory named ``{project_name}`` in the current working directory.

If you want to create a new project from the ICEkit `develop` branch, do this
instead::

   $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/develop/icekit/bin/startproject.sh) {project_name} develop

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
