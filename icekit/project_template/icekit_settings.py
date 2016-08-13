import os

# ENVIRONMENT #################################################################

# These environment variables are injected into the base settings module and
# used to derive other settings.

os.environ.setdefault('BASE_SETTINGS_MODULE', 'develop')
os.environ.setdefault('SITE_DOMAIN', 'icekit.lvh.me')
os.environ.setdefault('SITE_NAME', 'ICEkit')

from icekit.project.settings.calculated import *

# SECRETS #####################################################################

# Do not commit secrets to VCS.

# AWS_SECRET_ACCESS_KEY = ''
# DATABASES['default']['PASSWORD'] = ''
# EMAIL_HOST_PASSWORD = ''
# MASTER_PASSWORD = ''
# RAVEN_CONFIG['dsn'] = ''

# OVERRIDE ####################################################################

# These settings are absolute overrides. When overriding a calculated setting,
# be sure to override all of its derivative settings as well.
