from django import template
from django.template import Library


register = Library()


def get_item(obj, key):
    """
    Obtain an item in a dictionary style object.

    :param obj: The object to look up the key on.
    :param key: The key to lookup.
    :return: The contents of the the dictionary lookup.
    """
    try:
        return obj[key]
    except KeyError:
        return None

# Make this registration here instead of decorating the functions as the function may be called by
# other functions
register.filter(get_item)
# This is registered under a unique name in case the implementation needs to change in the future.
register.filter('get_slot_contents', get_item)


@register.simple_tag(name='get_slot_contents', takes_context=True)
def get_slot_contents_tag(context, descriptor, slot_name, define_as='', variable_name=None):
    """
    `get_slot_contents` accepts arguments in the formats:
    `{% get_slot_contents <slot descriptor> <slot name> %}` or
    `{% get_slot_contents <slot descriptor> <slot name> as <variable_name> %}`
    """
    if define_as:
        raise template.TemplateSyntaxError(
            '`get_slot_contents` accepts arguments in the formats: \n'
            '`{% get_slot_contents <slot descriptor> <slot name> %}` or \n'
            '`{% get_slot_contents <slot descriptor> <slot name> as <variable_name> %}`'
        )

    slot_contents = get_item(descriptor, slot_name)

    if variable_name is not None:
        context[variable_name] = slot_contents
        return ''

    return slot_contents
