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

wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/bower.json
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/docker-compose.override.yml
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/docker-compose.yml
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/docker-stack.sample.yml
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/Dockerfile
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/go.sh
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/package.json
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/requirements.txt
wget -nv https://raw.githubusercontent.com/ic-labs/django-icekit/feature/project/icekit/project_template/settings.py

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

All done!

Build an image and start the project with Docker:

    $ cd ${DEST_DIR}
    $ docker-compose build
    $ docker-compose up

Open the site in a browser:

    http://lvh.me

Or to run directly, go to https://github.com/ic-labs/django-icekit/#run-directly

EOF
