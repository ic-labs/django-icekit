# Run without Docker

If you are not yet ready for Docker, you can run an ICEkit project directly.
You will need to install and configure all of its dependencies manually.

Install required system packages:

  * Elasticsearch
  * md5sum
  * Nginx
  * NPM
  * PostgreSQL
  * Python 2.7
  * Redis

On OS X, we recommend [Postgres.app](http://postgresapp.com/). It is easy to
install, start, stop, and upgrade.

The rest can be installed with [Homebrew](http://brew.sh/):

    $ brew install elasticsearch md5sha1sum nginx npm python redis

You need to configure Elasticsearch, PostgreSQL and Redis to start
automatically, or start them manually before you start the project.

Open a subshell with a reconfigured environment for your project:

    $ ./go.sh  # Watch for the admin account credentials that get created on first run

Start the project:

    $ supervisord.sh

Now you can open the site in a browser:

    http://icekit.lvh.me:8000  # *.lvh.me is a wildcard DNS that maps to 127.0.0.1
