# Install ICEkit without Docker

If you are not yet ready for Docker, you can run the ICEkit project template
(or an ICEkit project) directly. You will need to install and configure all of
its dependencies manually.

## Install development tools (on a new development machine)

Install development tools. On OS X, install the XCode command line tools:

    xcode-select --install

## Install ICEkit system dependencies (only necessary the first time you install
an ICEkit project)

Install required system packages:

  * PostgreSQL
  * Elasticsearch
  * git-secret
  * md5sum
  * Nginx
  * NPM
  * Pipe Viewer
  * Python 2.7
  * Redis
  * zlib

### Database

ICEkit requires a PostgreSQL database. On OS X, we recommend
[Postgres.app](http://postgresapp.com/). It is easy to install, start,
stop, and upgrade.

We recommend that you configure Postgres to start automatically, using
Postgres.app's preferences pane.

Alternatively, you can install Postgres using [Homebrew](http://brew.sh/) with
`brew install postgres`. Follow the instructions to configure Postgres to start
automatically.

### Homebrew

The rest can be installed with [Homebrew](http://brew.sh/):

    $ brew install elasticsearch git-secret md5sha1sum nginx npm pv python redis

zlib needs to be installed from the `dupes` repository and force linked:

    $ brew tap homebrew/dupes
    $ brew install zlib
    $ brew link zlib --force

You need to configure Elasticsearch and Redis to start
automatically, or start them manually before you start the project.

### Install Bower

    npm install -g bower

### Repairing installation after an OS X upgrade

If you experience errors running `./go.sh` after an upgrade to OS X try
installing Xcode command-line tools:

    xcode-select --install

You may also need to re-install system packages.

## Run without Docker

Change to the ICEkit project template (or an ICEkit project) directory:

    $ cd project_template

Open a shell with the environment appropriately configured (dependencies
updated, database set up):

    $ ./go.sh

(After installing, you can skip installing dependencies and migrations and head
directly to a shell with `./go.sh bash`)

Create a superuser account:

    $ manage.py createsuperuser

Run the Django dev server:

    $ runserver.sh

Now you can open the site in a browser:

    http://localhost:8000
