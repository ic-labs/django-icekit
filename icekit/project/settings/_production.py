from ._base import *

# DJANGO ######################################################################

CACHES['default'].update({
    # 'BACKEND': 'django_redis.cache.RedisCache',
    'BACKEND': 'redis_lock.django_cache.RedisCache',
    'LOCATION': 'redis://redis:6379/1',
})

LOGGING['handlers']['logfile']['backupCount'] = 100

# CELERY EMAIL ################################################################

CELERY_EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

# STORAGES ####################################################################

ENABLE_S3_MEDIA = True
