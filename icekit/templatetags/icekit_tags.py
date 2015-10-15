from django import template
from django.template import Library


register = Library()


def get_slot_contents(descriptor, slot_name):
    """
    Obtain a slots content from a descriptor.

    :param descriptor: The descriptor to look up the slot on.
    :param slot_name: The name of the slot to lookup.
    :return: List of items available in the slot.
    """
    try:
        return descriptor[slot_name]
    except KeyError:
        return None

# Make this registration here instead of decorating the functions as the function may be called by
# other functions
register.filter(get_slot_contents)


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

    slot_contents = get_slot_contents(descriptor, slot_name)

    if variable_name is not None:
        context[variable_name] = slot_contents
        return ''

    return slot_contents
