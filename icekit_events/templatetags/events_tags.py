from django import template
from django.template.defaultfilters import time

register = template.Library()

@register.filter
def times(times_list, format=None):
    """
    :param times_list: the list of times to format
    :param format: the format to apply (default = settings.TIME_FORMAT)
    :return: the times, formatted according to the format
    """
    return [time(t, format) for t in times_list]
