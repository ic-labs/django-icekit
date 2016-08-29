from ._test import *

# DJANGO ######################################################################

CACHES['default'].update({
    'LOCATION': 'redis://localhost:6379/1',
})

# CELERY ######################################################################

BROKER_URL = 'redis://localhost:6379/0'
