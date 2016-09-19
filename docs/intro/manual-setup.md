# Install and run ICEkit without Docker

If you are not yet ready for Docker, you can run the ICEkit project template
(or an ICEkit project) directly. You will need to install and configure all of
its dependencies manually.

## Install system packages

Install required system packages:

  * Elasticsearch
  * md5sum
  * Nginx
  * NPM
  * Pipe Viewer
  * PostgreSQL
  * Python 2.7
  * Redis
  * zlib

On OS X, we recommend [Postgres.app](http://postgresapp.com/). It is easy to
install, start, stop, and upgrade.

The rest can be installed with [Homebrew](http://brew.sh/):

    $ brew install elasticsearch md5sha1sum nginx npm pv python redis

zlib needs to be installed from the `dupes` repository and force linked:

    $ brew tap homebrew/dupes
    $ brew install zlib
    $ brew link zlib --force

You need to configure Elasticsearch, PostgreSQL and Redis to start
automatically, or start them manually before you start the project.

## Run without Docker

Change to the ICEkit project template (or an ICEkit project) directory:

    $ cd project_template

Open a shell with the environment appropriately configured:

    $ ./go.sh

Install Node modules, Bower components and Python requirements, create a
database, and apply Django migrations:

    $ setup-django.sh

Create a superuser account:

    $ manage.py createsuperuser

Run the project:

    $ supervisord.sh

Now you can open the site in a browser:

    http://localhost:8000

Stop all services:

    $ supervisorctl.sh stop all

Run the tests:

    $ runtests.sh
