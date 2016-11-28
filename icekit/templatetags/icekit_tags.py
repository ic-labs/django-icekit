import urlparse

import re

from django import template
from django.conf import settings
from django.http import QueryDict
from django.template import Library
from django.utils.encoding import force_text
from django.utils.safestring import mark_safe
from fluent_contents.plugins.oembeditem.backend import get_oembed_data
from icekit.utils.admin.urls import admin_link as admin_link_fn, admin_url as admin_url_fn
from micawber import ProviderException

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

def grammatical_join(l, initial_joins=", ", final_join=" and "):
    """
    http://stackoverflow.com/questions/19838976/grammatical-list-join-in-python

    :param l: List of strings to join
    :param initial_joins: the string to join the non-ultimate items with
    :param final_join: the string to join the final item with
    :return: items joined with commas except " and " before the final one.
    """
    return initial_joins.join(l[:-2] + [final_join.join(l[-2:])])

def _grammatical_join_filter(l, arg=None):
    """
    :param l: List of strings to join
    :param arg: A pipe-separated list of final_join (" and ") and
    initial_join (", ") strings. For example
    :return: A string that grammatically concatenates the items in the list.
    """
    if not arg:
        arg = " and |, "
    try:
        final_join, initial_joins = arg.split("|")
    except ValueError:
        final_join = arg
        initial_joins = ", "
    return grammatical_join(l, initial_joins, final_join)
register.filter("grammatical_join", _grammatical_join_filter)


"""
update_GET allows you to substitute parameters into the current request's
GET parameters. This is useful for updating search filters without losing
the current set.

<a href="?{% update_GET 'attr1' += value1 'attr2' -= value2 'attr3' = value3 %}">foo</a>
This adds value1 to (the list of values in) 'attr1',
removes value2 from (the list of values in) 'attr2',
sets 'attr3' to value3.

And returns a urlencoded GET string.

Allowed values are:
    strings, in quotes
    vars that resolve to strings
    lists of strings
    None (without quotes)

If a attribute is set to None or an empty list, the GET parameter is removed.
If an attribute's value is an empty string, or [""] or None, the value remains, but has a "" value.
If you try to =- a value from a list that doesn't contain that value, nothing happens.
If you try to =- a value from a list where the value appears more than once, only the first value is removed.
"""

@register.tag(name='update_GET')
def do_update_GET(parser, token):
    try:
        args = token.split_contents()[1:]
        triples = list(_chunks(args, 3))
        if triples and len(triples[-1]) != 3:
            raise template.TemplateSyntaxError, "%r tag requires arguments in groups of three (op, attr, value)." % token.contents.split()[0]
        ops = set([t[1] for t in triples])
        if not ops <= set(['+=', '-=', '=']):
            raise template.TemplateSyntaxError, "The only allowed operators are '+=', '-=' and '='. You have used %s" % ", ".join(ops)

    except ValueError:
        return UpdateGetNode()

    return UpdateGetNode(triples)

def _chunks(l, n):
    """ Yield successive n-sized chunks from l.
    """
    for i in xrange(0, len(l), n):
        yield l[i:i+n]


# removed in Django 1.8
unencoded_ampersands_re = re.compile(r'&(?!(\w+|#\d+);)')
def fix_ampersands(value):
    """Returns given HTML with all unencoded ampersands encoded correctly."""
    return unencoded_ampersands_re.sub('&amp;', force_text(value))


class UpdateGetNode(template.Node):
    def __init__(self, triples=[]):
        self.triples = [(template.Variable(attr), op, template.Variable(val)) for attr, op, val in triples]

    def render(self, context):
        try:
            GET = context.get('request').GET.copy()
        except AttributeError:
            GET = QueryDict("", mutable=True)

        for attr, op, val in self.triples:
            actual_attr = attr.resolve(context)

            try:
                actual_val = val.resolve(context)
            except:
                if val.var == "None":
                    actual_val = None
                else:
                    actual_val = val.var

            if actual_attr:
                if op == "=":
                    if actual_val is None or actual_val == []:
                        if GET.has_key(actual_attr):
                            del GET[actual_attr]
                    elif hasattr(actual_val, '__iter__'):
                        GET.setlist(actual_attr, actual_val)
                    else:
                        GET[actual_attr] = unicode(actual_val)
                elif op == "+=":
                    if actual_val is None or actual_val == []:
                        if GET.has_key(actual_attr):
                            del GET[actual_attr]
                    elif hasattr(actual_val, '__iter__'):
                        GET.setlist(actual_attr, GET.getlist(actual_attr) + list(actual_val))
                    else:
                        GET.appendlist(actual_attr, unicode(actual_val))
                elif op == "-=":
                    li = GET.getlist(actual_attr)
                    if hasattr(actual_val, '__iter__'):
                        for v in list(actual_val):
                            if v in li:
                                li.remove(v)
                        GET.setlist(actual_attr, li)
                    else:
                        actual_val = unicode(actual_val)
                        if actual_val in li:
                            li.remove(actual_val)
                        GET.setlist(actual_attr, li)

        return fix_ampersands(GET.urlencode())


@register.filter
def oembed(url, params=""):
    kwargs = dict(urlparse.parse_qsl(params))

    try:
        return mark_safe(get_oembed_data(
            url,
            **kwargs
        )['html'])
    except (KeyError, ProviderException):
        if settings.DEBUG:
            return "No OEmbed data returned"
        return ""


@register.filter
def admin_link(obj):
    return admin_link_fn(obj)


@register.filter
def admin_url(obj):
    return admin_url_fn(obj)

@register.filter
def link(obj):
    return mark_safe(u"<a href='{0}'>{1}</a>".format(obj.get_absolute_url(), unicode(obj)))