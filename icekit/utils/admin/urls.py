import warnings


warnings.warn(
    "the icekit.utils.admin.urls module is deprecated. Use icekit.admin_tools.utils instead.",
    DeprecationWarning,
    stacklevel=2)

from icekit.admin_tools.utils import \
    admin_url as new_admin_url, \
    admin_link as new_admin_link

def admin_url(inst):
    warnings.warn("'icekit.utils.admin.urls.admin_url' is renamed 'icekit.admin_tools.utils.admin_url'",
                  DeprecationWarning, stacklevel=2)
    return new_admin_url(inst)


def admin_link(inst):
    warnings.warn("'icekit.utils.admin.urls.admin_link' is renamed 'icekit.admin_tools.utils.admin_link'",
                  DeprecationWarning, stacklevel=2)
    return new_admin_link(inst)
