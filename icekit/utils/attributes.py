def resolve(obj, attr):
    """
    Resolves obj.attr to a value, calling it as a function if necessary.
    :param obj:
    :param attr: a string name of a property or function
    :return: the result of the attribute, or None if object/attr not found
    """
    if obj is None:
        return None
    attr = getattr(obj, attr, None)
    if callable(attr):
        return attr()
    return attr

def first_of(obj, *attrs):
    """
    :param obj:
    :param attrs: a list of strings
    :return: the first truthy attribute of obj, calling it as a function if necessary.
    """
    for attr in attrs:
        r = resolve(obj, attr)
        if r:
            return r