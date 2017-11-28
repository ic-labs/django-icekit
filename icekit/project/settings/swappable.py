
# Allows for Location model to be swapable
if ICEKIT_LOCATION_MODEL != 'icekit_plugins_location.Location':
    INSTALLED_APPS.remove('icekit.plugins.location')
    INSTALLED_APPS += (
        ICEKIT_LOCATION_INSTALLED_APPS_STRING,
    )
