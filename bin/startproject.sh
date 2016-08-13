#!/bin/bash

set -e

DEST_DIR="${1:-$PWD/icekit-project}"

cat <<EOF

This script will create a new ICEkit project in directory '${DEST_DIR}'.

EOF

read -p 'Press CTRL-C to abort or any other key to continue...'
echo

if [[ -z $(which wget) ]]; then
    echo "'wget' is not available. Please install it try again."
    exit 1
fi

mkdir -p "$DEST_DIR"
cd "$DEST_DIR"

wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/.dockerignore
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/.gitignore
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/bower.json
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/docker-compose.override.yml
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/docker-compose.yml
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/Dockerfile
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/icekit_settings.py
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/manage.py
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/package.json
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/README.md
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/requirements.txt

chmod +x manage.py

# Use basename of destination directory as Docker Hub repository name.
sed -i -e "s/icekit-project/$(basename $DEST_DIR)/" docker-compose.yml

if [[ -n $(which git) ]]; then
    echo
    read -p 'Would you like to initialize a Git repository for your new project and create an initial commit? (Y/n) ' -n 1 -r
    echo
    if [[ "${REPLY:-y}" =~ ^[Yy]$ ]]; then
        git init
        git add -A
        git commit -m 'Initial commit.'
    fi
fi

cat <<EOF

All done! What now? First, change to the project directory:

    $ cd ${DEST_DIR}

# Run with Docker

The easiest way to run an ICEkit project is with Docker. It works on OS X,
Linux, and Windows, takes care of all the project dependencies like the
database and search engine, and makes deployment easy.

If you haven't already, go install Docker:

  * [OS X](https://download.docker.com/mac/stable/Docker.dmg)
  * [Linux](https://docs.docker.com/engine/installation/linux/)
  * [Windows](https://download.docker.com/win/stable/InstallDocker.msi)

Build an image and start the project:

    $ docker-compose build
    $ docker-compose up

Start the project:

    $ docker-compose up

Now you can open the site:

    http://lvh.me

Read our [Docker Quick Start](https://github.com/ic-labs/django-icekit/blob/master/docs/docker-quick-start.md)
guide for more info on using Docker with an ICEkit project.

# Run directly

If you are not yet ready for Docker, you can run an ICEkit project directly.
You will just need to install and configure all of its dependencies manually.

See: https://github.com/ic-labs/django-icekit/#run-directly

EOF
