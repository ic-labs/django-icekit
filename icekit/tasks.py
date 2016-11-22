import os
from celery.task import Task
import logging
import redis

try:
    from celery import shared_task
except ImportError:
    def shared_task(f):
        f.delay = f
        return f

from django.conf import settings
from django.core.management import call_command
from django.db.models.loading import get_model


logger = logging.getLogger(__name__)

# Resources for `one_instance` task execution management decorator.
REDIS_CLIENT = redis.Redis()
DEFAULT_ONE_INSTANCE_TIMEOUT = getattr(settings, 'CELERY_TIMEOUT', 7200) * 1.1


def one_instance(function=None, key='', timeout=DEFAULT_ONE_INSTANCE_TIMEOUT):
    """
    Decorator to enforce only one Celery task execution at a time when multiple
    workers are available.

    See http://loose-bits.com/2010/10/distributed-task-locking-in-celery.html
    """
    def _dec(run_func):
        def _caller(*args, **kwargs):
            ret_value = None
            have_lock = False
            # Use Redis AOF for persistent lock.
            if REDIS_CLIENT.config_get('appendonly').values()[0] == 'no':
                REDIS_CLIENT.config_set('appendonly', 'yes')
            lock = REDIS_CLIENT.lock(key, timeout=timeout)
            try:
                logger.debug(
                    '%s: trying to acquire lock (PID %d).'
                    % (key, os.getpid()))
                have_lock = lock.acquire(blocking=False)
                if have_lock:
                    logger.debug(
                        '%s: acquired lock (PID %d).' % (key, os.getpid()))
                    ret_value = run_func(*args, **kwargs)
                else:
                    logger.error(
                        '%s: did not acquire lock (PID %d).'
                        % (key, os.getpid()))
            finally:
                if have_lock:
                    lock.release()
                    logger.debug(
                        '%s: released lock (PID %d).' % (key, os.getpid()))
            return ret_value
        return _caller
    return _dec(function) if function is not None else _dec


@shared_task
def store_readability_score(app_label, model_name, pk):
    # non-blockingly update the readability score for this work. Needs to happen after save, as all the m2m content
    # items are relevant
    cls = get_model(app_label, model_name)
    obj = cls.objects.get(pk=pk)
    obj.readability_score = obj.calculate_readability_score()
     # avoid calling save() recursively
    type(obj).objects.filter(pk=obj.pk).update(readability_score=obj.readability_score)


class UpdateSearchIndexTask(Task):
    @one_instance(key='UpdateSearchIndexTask')
    def run(self, **kwargs):
        call_command('update_index', remove=True)
