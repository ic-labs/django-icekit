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
# The filter is used as follows:
# {{ <page>.<descriptor>|get_slot_contents:<slot_name> }}
register.filter('get_slot_contents', get_item)


@register.assignment_tag(name='get_slot_contents')
def get_slot_contents_tag(descriptor, slot_name):
    """
    `get_slot_contents` accepts arguments in the format:
    `{% get_slot_contents <slot descriptor> <slot name> as <variable_name> %}`
    """
    return get_item(descriptor, slot_name)


@register.inclusion_tag('icekit/templatetags/link_share.html',
                        takes_context=True)
def link_share(context, text):
    return {
        'text': text,
        'ICEKIT_SHARE_USERNAME': context.get('ICEKIT_SHARE_USERNAME', ''),
        'ICEKIT_SHARE_KEY': context.get('ICEKIT_SHARE_KEY', ''),
    }
