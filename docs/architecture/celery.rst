Running tasks in the background using Celery *
============================================

.. TODO: more from SFMOMA docs

In ICEkit background tasks are queued using Celery, and scheduled in
``crontab``-like fashion using CeleryBeat.

To check Celery tasks are running
---------------------------------

check the log (stdout) of the Celery Docker container for actual tasks
being executed. Check the logs (stdout) of the celerybeat container to
ensure the scheduled tasks process is running.
