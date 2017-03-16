import warnings

warnings.warn(
    "the icekit.admin_forms module is deprecated. Use icekit.admin_tools.forms instead.",
    DeprecationWarning,
    stacklevel=2)


from icekit.utils.deprecation import deprecated

from icekit.admin_tools.forms import PasswordResetForm as new_PasswordResetForm

@deprecated
class PasswordResetForm(new_PasswordResetForm):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.forms.PasswordResetForm` instead.
    """
    pass
