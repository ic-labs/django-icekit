def resolve(obj, attr, fallback=None):
    """
    Resolves obj.attr to a value, calling it as a function if necessary.
    :param obj:
    :param attr: a string name of a property or function
    :param fallback: the value to return if none can be resolved
    :return: the result of the attribute, or fallback if object/attr not found
    """
    if obj is None:
        return fallback
    value = getattr(obj, attr, fallback)
    if callable(value):
        return value()
    return value

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