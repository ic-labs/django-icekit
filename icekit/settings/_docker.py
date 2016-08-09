from ._develop import *

# DJANGO ######################################################################

CACHES['default'].update({
    'BACKEND': 'redis_lock.django_cache.RedisCache',
    'LOCATION': 'redis://redis:6379/1',
})

# CELERY ######################################################################

BROKER_URL = 'redis://redis:6379/0'
