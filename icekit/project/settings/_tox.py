from ._test import *

# CELERY ######################################################################

BROKER_URL = 'redis://%s/0' % REDIS_ADDRESS
