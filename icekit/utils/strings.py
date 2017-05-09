def is_empty(value):
    """
    Return `True` if the given value is `None` or empty after `strip()`
    """
    return value is None or not value.strip()
