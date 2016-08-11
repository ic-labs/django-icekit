from django import template

from icekit.publishing import utils


register = template.Library()


@register.filter
def get_draft_url(url):
    """
    Return the given URL with a draft mode HMAC in its querystring.
    """
    return utils.get_draft_url(url)
