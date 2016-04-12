# Getting started

The easiest way to create and run an ICEkit project is with Docker. It works
on Windows, OS X, and Linux.

If you are not yet familiar with Docker, check out our [Docker Quick Start][0]
guide and then come back here.

If you are still not yet ready for Docker, check out our [Manual Setup][1]
guide, which covers all the things that Docker would otherwise take care of.

[0]: https://github.com/ixc/django-icekit/docs/docker-quick-start.md
[1]: https://github.com/ixc/django-icekit/docs/manual-setup-guide.md

# Creating a new ICEkit project

    $ curl -L http://bit.ly/django-icekit-template | bash -s FOO

This script will create a new ICEkit project in a directory named `FOO` in the
current working directory, ready to hack on.

It might need to install 'pip' and 'virtualenv' into your global environment,
and will prompt for confirmation if it does.

# Running an ICEkit project with Docker

    $ cd FOO
    $ docker-compose up

The first time you run this, the images for all services defined in your
compose file will be downloaded or built.
