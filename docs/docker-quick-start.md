# Why use Docker?

Docker has many advantages over a simple Python virtualenv environment:

  * Eliminates the "works on my machine" problem by exactly reproducing an
    identical runtime environment everywhere.

  * Eliminates the need to install and run service dependencies directly on
    your OS, such as Elastic Search, PostgreSQL, Redis, etc.

  * Eliminates the need to install library dependencies directly on your OS,
    such as libjpeg, libtiff, etc.

  * Easy continuous deployment and rolling deployments on Docker Cloud via auto
    redeploy when a new image is built.

  * Much less (if any) downtime during deployments, because Node modules,
    Bower components and Python packages are already installed in the image.

# Installation (OS X)

Install [Docker Toolbox][docker-toolbox], but do not choose either "Quick Start
Terminal" or "Kitematic" during install.

Install [Dinghy][dinghy] for improved file sharing performance and a `*.docker`
wildcard DNS mapped to your Docker VM.

    $ brew tap codekitchen/dinghy
    $ brew install dinghy

    # Create a new Docker VM
    $ dinghy create --provider virtualbox  # Or `vmware`, if you have it installed

    # Configure Docker to use the Docker VM
    $ eval "$(dinghy shellinit)"
    $ echo 'eval "$(dinghy shellinit)"' >> ~/.profile  # or `~/.bashrc`, etc.

# Installation (Linux)

On Linux, install [Docker Engine][docker-engine] and
[Docker Compose][docker-compose]. Docker runs natively on Linux, so there is no
need for VirtualBox or DNS mapping.

# Cheat sheet

The typical Docker workflow is:

  * Define the image build instructions for each service with a `Dockerfile`.

  * Configure and manage a collection of services with a `docker-compose.yml`
    file.

  * During local development, mount your source directory into containers for
    rapid iteration without having to rebuild images.

Here are some of the most commonly used Docker commands when getting started:

    # Rebuild service images defined in your compose file
    $ docker-compose build --pull

    # Start all services in your compose file
    $ docker-compose up

    # Stop all services in your compose file
    $ docker-compose stop

    # List all containers for services in your compose file
    $ docker-compose ps -a

    # Open a new shell inside an already running container for the `django` service
    $ docker-compose exec django entrypoint.sh bash

    # Remove all stopped containers and their data volumes
    docker rm -v $(docker ps -a -q -f status=exited)

    # Remove all "dangling" images (untagged and not referenced by a container)
    docker rmi $(docker images -f "dangling=true" -q)

    # Remove ALL images (start from scratch)
    docker rmi $(docker images -q)

[dinghy]: https://github.com/codekitchen/dinghy
[docker-compose]: https://docs.docker.com/compose/install/
[docker-engine]: https://docs.docker.com/engine/installation/
[docker-toolbox]: https://www.docker.com/products/docker-toolbox
