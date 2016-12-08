from ._test import *

# DJANGO ######################################################################

CACHES['default'].update({'BACKEND': 'redis_lock.django_cache.RedisCache'})

# CELERY ######################################################################

BROKER_URL = 'redis://%s/0' % REDIS_ADDRESS
