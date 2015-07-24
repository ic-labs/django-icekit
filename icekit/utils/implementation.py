from django.conf import settings


def check_settings(required_settings):
    """
    Checks all settings required by a module have been set.

    If a setting is required and it could not be found a
    NotImplementedError will be raised informing which settings are
    missing.

    :param required_settings: List of settings names (as strings) that
    are anticipated to be in the settings module.
    :return: None.
    """
    defined_settings = [
        setting if hasattr(settings, setting) else None for setting in required_settings
    ]

    if not all(defined_settings):
        raise NotImplementedError(
            'The following settings have not been set: %s' % ', '.join(
                set(required_settings) - set(defined_settings)
            )
        )
