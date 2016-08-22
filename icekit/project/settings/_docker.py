from ._develop import *

# DJANGO ######################################################################

CACHES['default'].update({
    # 'BACKEND': 'django_redis.cache.RedisCache',
    'BACKEND': 'redis_lock.django_cache.RedisCache',
    'LOCATION': 'redis://redis:6379/1',
})

# CELERY ######################################################################

BROKER_URL = 'redis://redis:6379/0'
