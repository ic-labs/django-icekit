def allowed_to_preview(user):
    """
    Is the user allowed to view the preview?

    Users are only allowed to view the preview if they are authenticated, active and staff.

    :param user: A User object instance.
    :return: Boolean.
    """
    if (
        user.is_authenticated and
        user.is_active and
        user.is_staff
    ):
        return True
    return False
