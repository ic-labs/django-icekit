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
        return (u for u in super(PasswordResetForm, self).get_users(email) if u.is_staff)
