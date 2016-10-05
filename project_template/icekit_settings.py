# Do not commit secrets to VCS.

# Local environment variables will be loaded from `.env.local`.
# Additional environment variables will be loaded from `.env.$DOTENV`.
# Local settings will be imported from `icekit_settings_local.py`

from icekit.project.settings.calculated import *

# OVERRIDE ####################################################################
# Override the default ICEkit settings to form project settings.

# Add apps for your project here.
INSTALLED_APPS += (
    # 'debug_toolbar',

    # INSTALLED BY SETUP.PY
    'sponsors',
    'press_releases',

    # INCLUDED IN PROJECT TEMPLATE
    'articles',
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
