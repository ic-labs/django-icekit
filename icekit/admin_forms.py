from django.contrib.auth import get_user_model
from django.contrib.auth.forms import PasswordResetForm


class PasswordResetForm(PasswordResetForm):
    """
    An extended Password reset form designed for staff users.

    It limits the users allowed to use this form the send them a
    password reset email to staff users only.
    """
    def get_users(self, email):
        """
        Make sure users are staff users.

        Additionally to the other PasswordResetForm conditions ensure
        that the user is a staff user before sending them a password
        reset email.

        :param email: Textual email address.
        :return: List of users.
        """
        # Django 1.8 supports this feature.
        if hasattr(super(PasswordResetForm, self), 'get_users'):
            return (
                u for u in super(PasswordResetForm, self).get_users(email)
                if u.is_staff and u.is_active
            )

        # Django Django < 1.8 support we can do this manually.
        active_users = get_user_model()._default_manager.filter(email__iexact=email, is_active=True)
        return (u for u in active_users if u.has_usable_password() and u.is_staff and u.is_active)
