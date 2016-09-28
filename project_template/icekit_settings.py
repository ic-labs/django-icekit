import os

# ENVIRONMENT #################################################################

# These environment variables are read by the base settings module and used to
# derive other settings, which is why we don't list them as overrides, after
# the base settings module has been imported.

# os.environ.setdefault('BASE_SETTINGS_MODULE', 'base')  # develop, production, test
os.environ.setdefault('SITE_DOMAIN', 'project_template.lvh.me')  # *.lvh.me is a wildcard DNS that maps to 127.0.0.1
os.environ.setdefault('SITE_NAME', 'project_template')
# os.environ.setdefault('EMAIL_HOST', '')
# os.environ.setdefault('EMAIL_HOST_USER', '')
# os.environ.setdefault('MEDIA_AWS_ACCESS_KEY_ID', '')
# os.environ.setdefault('MEDIA_AWS_STORAGE_BUCKET_NAME', '')
# os.environ.setdefault('PGDATABASE', '')
# os.environ.setdefault('PGHOST', '')
# os.environ.setdefault('PGPORT', '')
# os.environ.setdefault('PGUSER', '')

# SECRETS #####################################################################

# Do not commit secrets to VCS.

# os.environ.setdefault('EMAIL_HOST_PASSWORD', '')
# os.environ.setdefault('MASTER_PASSWORD', '')
# os.environ.setdefault('MEDIA_AWS_SECRET_ACCESS_KEY', '')
# os.environ.setdefault('PGPASSWORD', '')
# os.environ.setdefault('SENTRY_DSN', '')

# ICEKIT ######################################################################

from icekit.project.settings.calculated import *

# OVERRIDE ####################################################################

# These settings are absolute overrides. When overriding a calculated setting,
# be sure to override all of its derivative settings as well.
# Add apps for your project here.
INSTALLED_APPS += (
    # 'debug_toolbar',

    # INSTALLED BY SETUP.PY
    'sponsors',
    'press_releases',
    'icekit_events',

    # INCLUDED IN PROJECT TEMPLATE
    'articles',
    'events',
)

MIDDLEWARE_CLASSES += (
    # 'debug_toolbar.middleware.DebugToolbarMiddleware',
)

# Add "Articles" to the dashboard.
FEATURED_APPS[0]['models']['glamkit_articles.Article'] = {
    'verbose_name_plural': 'Articles',
}

ICEKIT['LAYOUT_TEMPLATES'] += (
    (
        SITE_NAME,
        os.path.join(PROJECT_DIR, 'templates/layouts'),
        'layouts',
    ),
)
