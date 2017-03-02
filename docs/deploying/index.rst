Deploying your site
===================

ICEkit is designed to be easily deployed and scaled using Docker.
See :doc:`../topics/docker`.

Your project's ``Dockerfile`` is used to prepare a Docker image. It looks
something like::

   FROM interaction/icekit:local

   WORKDIR /opt/project_template/

   COPY package.json /opt/project_template/
   RUN npm-install.sh && rm -rf /root/.npm
   ENV PATH=/opt/project_template/node_modules/.bin:$PATH

   COPY bower.json /opt/project_template/
   RUN bower-install.sh && rm -rf /root/.cache/bower

   COPY requirements.txt /opt/project_template/
   RUN pip install --no-cache-dir -r requirements.txt
   RUN md5sum requirements.txt > requirements.txt.md5

   ENV ICEKIT_PROJECT_DIR=/opt/project_template

   COPY . /opt/project_template/

   RUN manage.py collectstatic --noinput --verbosity=0
   RUN manage.py compress --verbosity=0

When you build an image, Docker steps through the Dockerfile, following
the instructions therein.


Deploy a Demo to Docker Cloud
-----------------------------

Use the Deploy to Docker Cloud button to create a new default ICEkit stack on
`Docker Cloud`_.

.. image:: https://files.cloud.docker.com/images/deploy-to-dockercloud.svg
   :target: https://cloud.docker.com/stack/deploy/?repo=https://github.com/ic-labs/django-icekit/
   :alt: Deploy to Docker Cloud

(This is mostly for testing and demonstration purposes - you won't be able to
customise your project when deploying the official ICEkit Docker image this way.)

.. TODO: document how to deploy your own project for the first time.

Deploying your project for the first time
-----------------------------------------

This section is a summary of the `Docker getting started <https://docs.docker.com/engine/getstarted/step_four/>`__
instructions.

The process of deploying a site for the first time is:

0. Create a `Docker Hub <https://hub.docker.com/>`__ account. You can use this
   for all the official Docker services, including Docker Cloud.

1. Build and tag an image from your Dockerfile::

      docker build -t "$DOCKER_ID_USER/$PROJECT_NAME:master"

   You can use anything instead of "master" here - we recommend using
   the name of the git branch you use for production deployments.

2. Push the image to Docker Hub::

      docker push "$DOCKER_ID_USER/$PROJECT_NAME:master"


   It should now appear in the `Repositories` section on Docker Cloud.

3. Set up a new stack in Docker Cloud. This needs more documentation (see the
   `Docker Cloud docs <https://docs.docker.com/docker-cloud/>`__ for more).
   For now, here's a sample production stackfile::

      django:
        environment:
          - AWS_ACCESS_KEY_ID=...
          - AWS_SECRET_ACCESS_KEY=...
          - AWS_STORAGE_BUCKET_NAME=...
          - BASE_SETTINGS_MODULE=production
          - EMAIL_HOST=...
          - EMAIL_HOST_PASSWORD=...
          - EMAIL_HOST_USER=...
          - FORCE_SSL=yes
          - PGHOST=...
          - PGPASSWORD=...
          - PGUSER=...
          - PYTHONWARNINGS=ignore
          - 'SECRET_KEY=...'
          - SITE_DOMAIN=www.mydomain.com.au
          - 'VIRTUAL_HOST=www.domain.com.au,https://www.mydomain.com.au'
        expose:
          - '8080'
        image: '$DOCKER_ID_USER/$PROJECT_NAME:master'
        links:
          - elasticsearch
          - redis
        restart: on-failure
        sequential_deployment: true
        tags:
          - production
        volumes:
          - /opt/$PROJECT_NAME/var
      elasticsearch:
        image: 'interaction/elasticsearch-icu:1'
        restart: on-failure
        tags:
          - production
      redis:
        command: redis-server --appendonly yes
        image: 'redis:3-alpine'
        restart: on-failure
        tags:
          - production
        target_num_containers: 2



Subsequent deployments
----------------------

When you want to release an update to your site, we suggest following these
steps:

1. Build your code into a Docker Image.

2. Ensure that tests run on the Docker Image.

3. Push the Image to Docker Hub.

4. Deploy the Image using Docker Cloud.

5. Check it worked (view some key pages).


Automating releases with Travis and Docker Cloud
------------------------------------------------

In Travis
~~~~~~~~~

A Continuous Integration service like `Travis <https://travis-ci.com>`__ can
run tests and other commands automatically for every pushed revision.

The project template includes a ``.travis.yml`` file which instructs Travis
to build the Docker image, run tests on the built image, and if the tests
pass, to push the image to Docker Hub.

In Docker Cloud
~~~~~~~~~~~~~~~

You can set ``autoredeploy: true`` in your Docker Cloud stackfile to
automatically redeploy services when their Docker images are updated.

Here's an excerpt from a stackfile, which auto-redeploys when your
``{docker_hub_account}/{image_name}:{tag}`` image is updated (e.g.
``interaction/acmi:staging`` )
::

   django:
     autoredeploy: true
     image: '{docker_hub_account}/{image_name}:{tag}'
     ...
   elasticsearch:
     ...
   redis:
     ...

Fixing a broken deployment
--------------------------

There are any number of reasons why a deployment can break. Assuming your
app is unreachable, the best place to start is by looking at the logs in Docker
Cloud. You can also restart and redeploy the services using the Docker Cloud
tools.

Rolling back a deployment
~~~~~~~~~~~~~~~~~~~~~~~~~

`(You almost never want to do this -- the consistency of Docker and a good git
workflow makes it easy to check whether a deployment will break well before
it hits the production server.)`

First, identify the revision you want to roll back to. Depending on your git
workflow, this will either be the last merge to the production branch, or the
last release tag, or you may need to guess. This is your target revision.

Rolling back the data
`````````````````````
The main difficulty in rolling back is whether any Django migrations were
applied between the new/breaking release and the target revision, and whether
those migrations can be reversed.

If migrations have been applied, it's probably still going to be quicker and
less messyto fix the deployment or restore a database backup than to roll back
migrations.

Further, if any migrations don't have a `reverse()` operation specified, then
they can't be rolled back, and you'll either have to restore from a database
backup, improvise a `reverse()` operation, or do nothing and hope the target
revision is compatible enough to work.

If you're still determined to roll back the migrations, compare the breaking
and target revisions to see if any migrations were added to the codebase. If so,
then you must manually apply those migrations in reverse using::

   manage.py migrate {app} {4-digit migration number to reverse minus 1, or 'zero'}

Rolling back code
`````````````````
After you've rolled back migrations, update the Docker Cloud stack file and
change `master` tag to a full commit hash of the target release (you can get it
from Travis build history) and click redeploy.

That was fun
````````````
When the dust has settled, consider how to modify your process to avoid the
need to roll back deployments. We sugges:

-  Use Docker for consistent, repeatable server environments
-  Use a git-flow-based branching workflow for careful separation of features
   from main branches
-  Write tests, and never deploy unless unit tests pass.
-  Deploy release candidates to a staging environment first, which has
   recent copies of production data and media.
-  Deploy all of staging to production, not just the features that passed
   tests.
