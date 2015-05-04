from settings import *

INSTALLED_APPS += (
    'south',
)

SOUTH_MIGRATION_MODULES = {
    'icekit': 'icekit.south_migrations',
    'image': 'icekit.plugins.image.south_migrations',
    'brightcove': 'icekit.plugins.brightcove.south_migrations',
}
