# Manual setup

If you are not using Docker, you will need to install the required services and
library dependencies manually.

First, create your project the same way as if you were using Docker:

    $ bash <(curl -L http://bit.ly/ixc-project-template) FOO

This only creates the source code for a new project from our template. It does
not install any dependencies for the project.

On OS X, you can use Homebrew to install those dependencies:

    # Install Homebrew
    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Install project dependencies with Homebrew
    $ cd FOO
    $ brew bundle

Follow any instructions that come up on screen during installation.

You will need to create a local settings module to reconfigure some settings,
depending on how your services have been installed:

    $ cp djangosite/settings/local.sample.py djangosite/settings/local.py
    $ vi djangosite/settings/local.py

Create a database and Python virtualenv:

    $ createdb FOO
    $ pip install virtualenvwrapper
    $ mkvirtualenv -a $PWD FOO
    $ pip install -e .

Now you can apply database migrations and run the project:

    $ ./manage.py migrate
    $ ./manage.py runserver
