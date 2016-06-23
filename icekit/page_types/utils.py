import os
from django.conf import settings
from django.core.exceptions import ImproperlyConfigured


def get_pages_template_dir(setting_name, default_path=''):
    """
    Obtains the template directory from settings.

    If setting_name cannot be found it will fall back to the
    default_path specified or if that does not exist the first
    listed in TEMPLATE_DIRS list.

    :param setting_name: The name in settings.
    :return: The value in settings for the template directory.
    """
    setting = getattr(settings, setting_name, default_path)
    if not setting:
        setting = getattr(settings, 'TEMPLATE_DIRS', '')
        setting_name = 'TEMPLATE_DIRS[0]'
        if setting:
            setting = setting[0]
        else:
            raise ImproperlyConfigured(
                "The setting '%s' or 'TEMPLATE_DIRS[0]' need to be defined!" % setting_name
            )
    else:
        # Clean settings
        setting = setting.rstrip('/') + '/'

        if not os.path.isabs(setting):
            raise ImproperlyConfigured(
                "The setting '{0}' needs to be an absolute path!".format(setting_name)
            )
        if not os.path.exists(setting):
            raise ImproperlyConfigured(
                "The path '{0}' in the setting '{1}' does not exist!".format(
                    setting,
                    setting_name
                )
            )

    return setting
