from ._test import *

# DJANGO ######################################################################

CACHES['default'].update({
    'LOCATION': 'redis://%s/1' % REDIS_ADDRESS,
})

# CELERY ######################################################################

BROKER_URL = 'redis://%s/0' % REDIS_ADDRESS
