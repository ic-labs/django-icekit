from ._base import *

SITE_PUBLIC_PORT = None  # Default: SITE_PORT

# DJANGO ######################################################################

CACHES['default'].update({
    # 'BACKEND': 'django_redis.cache.RedisCache',
    'BACKEND': 'redis_lock.django_cache.RedisCache',
    'LOCATION': 'redis://redis:6379/1',
})

# EMAIL_HOST = ''
# EMAIL_HOST_USER = ''

LOGGING['handlers']['logfile']['backupCount'] = 100

MIDDLEWARE_CLASSES = (
    ('django.middleware.cache.UpdateCacheMiddleware', ) +
    MIDDLEWARE_CLASSES +
    ('django.middleware.cache.FetchFromCacheMiddleware', )
)

TEMPLATES_DJANGO['OPTIONS']['loaders'] = [
    (
        'django.template.loaders.cached.Loader',
        TEMPLATES_DJANGO['OPTIONS']['loaders'],
    ),
]

# CELERY EMAIL ################################################################

CELERY_EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

# NEW RELIC ###################################################################

# SUPERVISOR['django'] = 'newrelic-admin run-program %s' % SUPERVISOR['django']

# STORAGES ####################################################################

# AWS_ACCESS_KEY_ID = ''
AWS_STORAGE_BUCKET_NAME = SITE_SLUG
ENABLE_S3_MEDIA = True
