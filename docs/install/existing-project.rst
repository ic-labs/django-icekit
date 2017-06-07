Installing an existing GLAMkit project
======================================

The instructions for setting up an existing GLAMkit project are identical to
starting a new project, except instead of step 1. 'Create a new project'
(the ``$ bash <(curl ... `` line), just clone your git repository.

Matching a local copy to a server
---------------------------------

You may want to replicate a server instance on your development machine in
order to replicate reported behaviour for debugging. This is normally a
question of matching 1. the Django code, 2. the database and 3. the media.
The secondary services should be consistent across environments.

In practice, you normally only need:

- the latest revision of code you're working on
- a copy of the production database
- not all of the media (just create placeholder media for testing)

Matching the Django code
~~~~~~~~~~~~~~~~~~~~~~~~

Travis will tell you the commit hash of the last revision of the branch you wish
to match. Checkout this revision to match the server. Running
``docker-compose run`` or ``./go.sh`` should update the requirements to match
the installed version.

.. TODO: is there a way of telling the revision from Docker Cloud?

Matching the database
~~~~~~~~~~~~~~~~~~~~~

Follow the instructions in :ref:`data-dumps`.

Matching the media
~~~~~~~~~~~~~~~~~~

This is a question of ``rsync``-ing the server media with your local folder::

   rsync -zrv $HOST:$PATH_TO_MEDIA ./var/media_root

.. TODO: more explicit for s3 and wherever docker puts them.

Normally the media for a large website is in the several gigabytes, and isn't
often necessary to store locally in entirety. Instead, we suggest just rsyncing
particular files, or replacing them with placeholders.

.. TODO: do we have any fallback or placeholder approaches?
