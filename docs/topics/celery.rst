Running tasks in the background using Celery
============================================

Background tasks are run using
`Celery <http://docs.celeryproject.org/en/latest/django/first-steps-with-django.html>`__,
which delegates to Redis.

The project template's ``docker-compose.yml`` file configures ``redis``,
``celery``, ``celerybeat`` and ``celeryflower`` machines.

Running background tasks
------------------------

See the `Celery <http://docs.celeryproject.org/en/latest/django/first-steps-with-django.html>`__,
documentation for writing and running background tasks that take place in response to an event.

.. TODO when it's enabled:
   For example, a background task runs when a page is saved that calculates
   a readability score for the page.

In development
~~~~~~~~~~~~~~

The Celery-related services are started when you run ``docker-compose run``.

If you're not running Docker (and have Redis running on your machine) then, in
3 separate tabs, run::

   ./go.sh celery.sh # celery task runner
   ./go.sh celerybeat.sh # celery task scheduler
   ./go.sh celeryflower.sh # celery inspection service

On a server
~~~~~~~~~~~

Docker uses the included ``docker-compose.yml`` file to deploy your application
with all necessary services, including the Celery-related ones.

For more information, see :doc:`/deploying/index`.

Scheduling tasks
----------------

Tasks that need to run regularly are scheduled in ``crontab``-like fashion
using `CeleryBeat <http://docs.celeryproject.org/en/latest/userguide/periodic-tasks.html>`__.

You can define your tasks, wherever you like (we suggest in a file called
`tasks.py`). For example::

   from celery.task import Task
   from django.core.management import call_command
   from icekit.tasks import one_instance

   class UpdateSearchIndexTask(Task):
       @one_instance(key='UpdateSearchIndexTask')
       def run(self, **kwargs):
           call_command('update_index', remove=True)

.. admonition:: The ``one_instance`` decorator

   The ``icekit.tasks.one_instance`` decorator uses a Redis token to ensure that
   only one instance of the function will run at a time. This is useful in
   case tasks take longer to run than the interval between calls, but means
   that if tasks crash that the lock won't be released until
   ``settings.DEFAULT_ONE_INSTANCE_TIMEOUT`` seconds (default 7200) have
   elapsed.

Then you need to specify the task in a schedule, which is defined in
``settings.CELERYBEAT_SCHEDULE``, in this format::

   from celery.schedules import crontab

   CELERYBEAT_SCHEDULE = {
       'UpdateSearchIndexTask': {
           'task': 'icekit.tasks.UpdateSearchIndexTask',
           'schedule': crontab(minute='*/15'),  # Every 15 minutes.
       },
   }

Add your tasks to the dictionary to include them in the scheduler.

Troubleshooting
---------------

You can use `Celery Flower <http://flower.readthedocs.io/en/latest/>`__ to
monitor running tasks. Visit http://localhost:5555 (or
http://{{yourproject}}.lvh.me:5555 )to see the interface.

.. note::

   Restarting Flower (e.g. on deployment) will clear its records of tasks, so use
   with caution in production environments.


If Celery tasks fail, they will show up as failures. However, if celery tasks
'succeed' but with a very quick runtime (0.02 secs), the task
is possibly prevented from running by a ``one_instance`` lock.

Logging
~~~~~~~

Using Docker Cloud, you can also check the log (stdout) of the Celery Docker
container for actual tasks being executed. Check the logs (stdout) of the
Celery Beat container to ensure the scheduled tasks process is running.

See the `Celery Logging docs <http://docs.celeryproject.org/en/latest/userguide/tasks.html#logging>`__
for how to log, e.g.::

   from celery.utils.log import get_task_logger

   logger = get_task_logger(__name__)

   @app.task
   def add(x, y):
       logger.info('Adding {0} + {1}'.format(x, y))
       return x + y


Freeing task locks
~~~~~~~~~~~~~~~~~~

Locks are stored in Redis as keys with a TTL. You can see the locks in a
Python shell with::

    >>> import redis
    >>> REDIS_CLIENT = redis.Redis()
    >>> [x for x in REDIS_CLIENT.keys() if 'Task' in x]
    ['FetchCollectionDataTask', 'FindAndFetchNetxImagesTask', 'DeleteRemovedNetxImagesTask']
    >>> REDIS_CLIENT.pttl('FindAndFetchNetxImagesTask') # ms to live
    7693886L

(note that ``'Task' in x`` part assumes that your ``CELERYBEAT_SCHEDULE``
entries have ``Task`` in the key name. You can delete a key, thus freeing up
the lock, with::

    >>> REDIS_CLIENT.delete('FindAndFetchNetxImagesTask')

(a response of 1 means the lock was deleted, a response of 0 means it was not
found.)

