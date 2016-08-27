# Run without Docker

If you are not yet ready for Docker, you can run an ICEkit project directly.
You will need to install and configure all of its dependencies manually.

Install required system packages:

  * Elasticsearch
  * PostgreSQL
  * Python 2.7
  * Redis

On OS X, you can use [Homebrew](http://brew.sh/):

    $ brew install elasticsearch postgresql python redis

We recommend [Postgres.app](http://postgresapp.com/) for the database. It is
easier to start, stop, and upgrade than Homebrew.

You need to configure these services to start automatically, or start them
manually before you start the project.

Make a virtualenv and install required Python packages:

    $ pip install virtualenv
    $ virtualenv venv
    (venv)$ pip install -r requirements-icekit.txt

Start the project:

    (venv)$ ./go.sh supervisord.sh  # Watch for the admin account credentials that get created on first run

When you see the following message, you will know it is ready:

    #
    # READY.
    #

Now you can open the site in a browser:

    http://icekit.lvh.me:8000  # *.lvh.me is a wildcard DNS that maps to 127.0.0.1
