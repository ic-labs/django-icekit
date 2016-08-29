#!/bin/bash

set -e

DEST_DIR="${1:-$PWD/icekit-project}"
BRANCH="${2:-master}"

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

curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/.dockerignore"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/.gitignore"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/bower.json"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/docker-compose.override.yml"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/docker-compose.yml"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/Dockerfile"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/go.sh"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/icekit_settings.py"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/package.json"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/icekit/project_template/requirements-icekit.txt"

chmod +x go.sh
touch requirements.txt

# Use basename of destination directory as Docker Hub repository name.
sed -e "s/project_template/$(basename $DEST_DIR)/" -i '' docker-compose.yml

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

    $ docker-compose build --pull
    $ docker-compose up  # Watch for the admin account credentials that get created on first run

This will take a few minutes the first time. When you see the following
message, you will know it is ready:

    #
    # READY.
    #

Now you can open the site:

    http://icekit.lvh.me:8000  # *.lvh.me is a wildcard DNS that maps to 127.0.0.1

Read our [Docker Quick Start](https://github.com/ic-labs/django-icekit/blob/${BRANCH}/docs/docker-quick-start.md)
guide for more info on running an ICEkit project with Docker.

# Run without Docker

Read our [Manual Setup](https://github.com/ic-labs/django-icekit/blob/develop/docs/manual-setup.md)
guide for more info on running an ICEkit project without Docker.

EOF
