# Install and run ICEkit without Docker

If you are not yet ready for Docker, you can run the ICEkit project template
(or an ICEkit project) directly. You will need to install and configure all of
its dependencies manually.

## Install system packages

Install required system packages:

  * Elasticsearch
  * git-secret
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

    $ brew install elasticsearch git-secret md5sha1sum nginx npm pv python redis

zlib needs to be installed from the `dupes` repository and force linked:

    $ brew tap homebrew/dupes
    $ brew install zlib
    $ brew link zlib --force

You need to configure Elasticsearch, PostgreSQL and Redis to start
automatically, or start them manually before you start the project.

### Installing after an OS X upgrade

If you experience errors running `./go.sh` after an upgrade to OS X try
installing Xcode command-line tools:

    xcode-select --install

You may also need to re-install system packages.

## Run without Docker

Change to the ICEkit project template (or an ICEkit project) directory:

    $ cd project_template

Open a shell with the environment appropriately configured:

    $ ./go.sh

Create a superuser account:

    $ manage.py createsuperuser

Run the Django dev server:

    $ runserver.sh

Now you can open the site in a browser:

    http://localhost:8000
