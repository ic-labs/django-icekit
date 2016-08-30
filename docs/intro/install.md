# Installing ICEkit
<!-- keep identical with README -->

For detailed instructions, see [Manual Setup](manual-setup.md).

## 1. Start a new project

With [Docker installed and running](docker.md),
create a new project template with:

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) <project_name>

This script will create a new project in a directory named <project_name> in
the current working directory, ready to hack on. NOTE: Windows users should
run this command in Git Bash, which comes with
[Git for Windows](https://git-for-windows.github.io/).


## 2. Run the project

    $ cd <project_name>
    $ docker-compose build --pull
    $ docker-compose up

This will ensure all dependencies are installed and up to date, and will run
a development server. <strong>Watch for the admin account credentials that get created on first run</strong>.</p>

It will take a few minutes the first time. When you see the following message, you will know it is ready:

    #
    # READY.
    #

## 3. That's it!

Open your new GLAMkit site in a browser:

    http://<project_name>.lvh.me:8000

(`*.lvh.me` is a wildcard DNS that maps to 127.0.0.1)

# Next steps

* [Start building your site](../howto/start.md)
* [Features at a glance](features.md)
* [Architectural overview](architecture.md)
