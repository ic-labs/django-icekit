:orphan:

Installing and running without Docker
=====================================

If you are not yet ready for Docker, you can run an GLAMkit project directly.
You will need to install and configure all of its dependencies manually.

0. Install prerequisites (once per machine)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install development tools
-------------------------
Install development tools. On OS X, install the XCode command line
tools::

    xcode-select --install


Install GLAMkit system dependencies
-----------------------------------
This section describes how to install the required system packages:

-  PostgreSQL
-  Elasticsearch 2.x
-  git-secret
-  md5sum
-  Nginx
-  NPM
-  Pipe Viewer
-  Python 2.7
-  Redis
-  zlib

Database
........

GLAMkit requires a PostgreSQL database. On OS X, we recommend
`Postgres.app <http://postgresapp.com/>`__. It is easy to install,
start, stop, and upgrade.

We recommend that you configure Postgres to start automatically, using
Postgres.app's preferences pane.

Alternatively, you can install Postgres using
`Homebrew <http://brew.sh/>`__ with ``brew install postgres``. Follow
the instructions to configure Postgres to start automatically.

Homebrew
........

The rest can be installed with `Homebrew <http://brew.sh/>`__. Elastic search
 2.4 is keg-only so must be force-linked::

    $ brew install elasticsearch@2.4 git-secret md5sha1sum nginx npm pv python redis
    $ brew link elasticsearch@2.4 --force

You may want to use ``launchd`` to start these services and restart them at login::

    $ brew services start elasticsearch
    $ brew services start redis

zlib needs to be installed from the ``dupes`` repository and force
linked::

    $ brew tap homebrew/dupes
    $ brew install zlib
    $ brew link zlib --force

You need to configure Elasticsearch and Redis to start automatically, or
start them manually before you start the project.

Install Bower
.............

::

    npm install -g bower

.. tip:: Repairing installation after an OS X upgrade

    If you experience errors running ``./go.sh`` after an upgrade to OS X
    try installing Xcode command-line tools::

        xcode-select --install

    You may also need to re-install system packages.


.. include:: _new_project.rst

2. Run the project
^^^^^^^^^^^^^^^^^^

Change to the GLAMkit project template (or a GLAMkit project) directory::

    $ cd project_template

Open a shell with the environment appropriately configured (dependencies
updated, database set up)::

    $ ./go.sh

(After installing, you can skip installing dependencies and migrations
and head directly to a shell with ``./go.sh bash``.)

Create a superuser account::

    $ manage.py createsuperuser

Run the Django dev server::

    $ runserver.sh

3. That's it!
^^^^^^^^^^^^^

Open the site in a browser::

    http://{ my_project }.lvh.me:8000

When you're done, exit ``runserver.sh``.
