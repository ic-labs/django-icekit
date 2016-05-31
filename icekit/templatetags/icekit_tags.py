from django.conf import settings
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


@register.inclusion_tag('icekit/templatetags/link_share.html')
def link_share(text):
    return {
        'text': text,
        'share_username': getattr(settings, 'ICEKIT_SHARE_USERNAME', ''),
        'share_key': getattr(settings, 'ICEKIT_SHARE_KEY', ''),
    }
