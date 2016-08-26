# Manual Setup

If you are not using Docker, you will need to install the required services and
library dependencies manually.

First, create your project the same way as if you were using Docker:

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) FOO
    $ cd FOO

This only creates the source code for a new project from our template. It does
not install any dependencies for the project. You will need:

  * Elasticsearch
  * PostgreSQL
  * Redis

Create a database and Python virtualenv:

    $ createdb FOO
    $ pip install virtualenvwrapper
    $ mkvirtualenv -a $PWD FOO
    (FOO)$ pip install -e .

Now you can apply database migrations and run the project:

    (FOO)$ ./manage.py migrate
    (FOO)$ ./manage.py supervisor  # Starts all services

Open the site in your browser:

    http://localhost:8000
