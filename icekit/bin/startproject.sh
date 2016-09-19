#!/bin/bash

set -e

DEST_DIR="$1"
BRANCH="${2:-master}"

if [[ -z "$DEST_DIR" ]];
    >&2 echo 'You must specify a destination directory.'
    exit 1
fi

if [[ -d "$DEST_DIR" ]];
    >&2 echo "Destination directory '$DEST_DIR' already exists."
    exit 1
fi

DEST_DIR_BASENAME="$(basename $DEST_DIR)"

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

curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/.coveragerc"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/.dockerignore"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/.gitignore"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/bower.json"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/docker-compose.override.yml"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/docker-compose.yml"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/Dockerfile"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/go.sh"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/icekit_settings.py"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/package.json"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/requirements-icekit.txt"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/requirements.txt"
curl -#LO "https://raw.githubusercontent.com/ic-labs/django-icekit/${BRANCH}/project_template/test_initial_data.sql"

chmod +x go.sh
touch requirements.txt

# Find and replace 'project_template' with destination directory basename.
find . -type f -exec sed -e "s/project_template/$DEST_DIR_BASENAME/g" -i '' {} \;

# Replace editable with package requirement.
sed -e "s/-e ../django-icekit/" -i '' requirements-icekit.txt

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
