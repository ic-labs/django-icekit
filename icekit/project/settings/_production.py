from ._base import *

# DJANGO ######################################################################

# CACHES['default'].update({'BACKEND': 'redis_lock.django_cache.RedisCache'})
LOGGING['handlers']['logfile']['backupCount'] = 100

# TEMPLATES_DJANGO['OPTIONS']['loaders'] = [
#     (
#         'django.template.loaders.cached.Loader',
#         TEMPLATES_DJANGO['OPTIONS']['loaders'],
#     ),
# ]

# CELERY EMAIL ################################################################

CELERY_EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

# STORAGES ####################################################################

ENABLE_S3_MEDIA = True
