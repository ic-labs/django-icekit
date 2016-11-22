import htmlentitydefs

import re

from django.contrib.auth.models import AnonymousUser
from django.template import Library, Node
from django.test.client import RequestFactory


register = Library()
factory = RequestFactory()


class FakeRequestNode(Node):
    def render(self, context):
        req = factory.get('/')
        req.notifications = []
        req.user = AnonymousUser()
        context['request'] = req

        return ''


@register.tag
def fake_request(parser, token):
    """
    Create a fake request object in the context
    """
    return FakeRequestNode()


@register.filter
def unescape(text):
    """
    Removes HTML or XML character references and entities from a text string.

    :param text: The HTML (or XML) source text.
    :return: The plain text, as a Unicode string, if necessary.
    """
    def fixup(m):
        text = m.group(0)
        if text[:2] == "&#":
            # character reference
            try:
                if text[:3] == "&#x":
                    return unichr(int(text[3:-1], 16))
                else:
                    return unichr(int(text[2:-1]))
            except ValueError:
                pass
        else:
            # named entity
            try:
                text = unichr(htmlentitydefs.name2codepoint[text[1:-1]])
            except KeyError:
                pass
        return text # leave as is

    return re.sub("&#?\w+;", fixup, text)