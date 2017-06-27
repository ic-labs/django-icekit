import urlparse

import re
import warnings

from django import template
from django.conf import settings
from django.http import QueryDict
from django.template import Library
from django.template.base import Token, Variable
from django.template.loader_tags import do_include
from django.utils.text import slugify
from django.utils.encoding import force_text
from django.utils.safestring import mark_safe
from fluent_contents.plugins.oembeditem.backend import get_oembed_data
from micawber import ProviderException
from icekit.admin_tools.utils import admin_link as admin_link_fn, admin_url as admin_url_fn
from icekit.navigation import models as navigation_models

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
    Display a list of items nicely, with a different string before the final
    item. Useful for using lists in sentences.

    >>> grammatical_join(['apples', 'pears', 'bananas'])
    'apples, pears and bananas'

    >>> grammatical_join(['apples', 'pears', 'bananas'], initial_joins=";", final_join="; or ")
    'apples; pears; or bananas'

    :param l: List of strings to join
    :param initial_joins: the string to join the non-ultimate items with
    :param final_join: the string to join the final item with
    :return: items joined with commas except " and " before the final one.
    """
    # http://stackoverflow.com/questions/19838976/grammatical-list-join-in-python
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


@register.tag(name='update_GET')
def update_GET(parser, token):
    """
    ``update_GET`` allows you to substitute parameters into the current request's
    GET parameters. This is useful for updating search filters, page numbers,
    without losing the current set.

    For example, the template fragment::

        <a href="?{% update_GET 'attr1' += value1 'attr2' -= value2
        'attr3' = value3 %}">foo</a>

    -  adds ``value1`` to (the list of values in) ``'attr1'``,
    -  removes ``value2`` from (the list of values in) ``'attr2'``,
    -  sets ``attr3`` to ``value3``.
    and returns a urlencoded GET string.

    Allowed attributes are:

    -  strings, in quotes
    -  vars that resolve to strings

    Allowed values are:

    -  strings, in quotes
    -  vars that resolve to strings
    -  lists of strings
    -  None (without quotes)

    Note:

    -  If a attribute is set to ``None`` or an empty list, the GET parameter is
       removed.
    -  If an attribute's value is an empty string, or ``[""]`` or ``None``, the value
       remains, but has a ``""`` value.
    -  If you try to ``=-`` a value from a list that doesn't contain that value,
       nothing happens.
    -  If you try to ``=-`` a value from a list where the value appears more
       than once, only the first value is removed.
    """
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
    """
    Render an OEmbed-compatible link as an embedded item.


    :param url: A URL of an OEmbed provider.
    :return: The OEMbed ``<embed>`` code.
    """
    # Note: this method isn't currently very efficient - the data isn't
    # cached or stored.
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
    """
    Returns a link to the admin URL of an object.

    No permissions checking is involved, so use with caution to avoid exposing
    the link to unauthorised users.

    Example::

        {{ foo_obj|admin_link }}

    renders as::

        <a href='/admin/foo/123'>Foo</a>

    :param obj: A Django model instance.
    :return: A safe string expressing an HTML link to the admin page for an
    object.
    """
    if hasattr(obj, 'get_admin_link'):
        return mark_safe(obj.get_admin_link())
    return mark_safe(admin_link_fn(obj))


@register.filter
def admin_url(obj):
    """
    Returns the admin URL of the object.

    No permissions checking is involved, so use with caution to avoid exposing
    the link to unauthorised users.

    Example::

        {{ foo_obj|admin_url }}

    renders as::

        /admin/foo/123

    :param obj: A Django model instance.
    :return: the admin URL of the object
    """
    if hasattr(obj, 'get_admin_url'):
        return mark_safe(obj.get_admin_url())
    return mark_safe(admin_url_fn(obj))


@register.filter
def link(obj):
    """
    Returns a link to the object. The URL of the link is
    ``obj.get_absolute_url()``, and the text of the link is ``unicode(obj)``.

    Example::

        {{ foo_obj|link }}

    renders as::

        <a href='/foo/'>Foo</a>

    :param obj: A Django model instance.
    :return: A safe string expressing an HTML link to the object.
    """
    return mark_safe(u"<a href='{0}'>{1}</a>".format(obj.get_absolute_url(), unicode(obj)))


@register.tag
def deprecate_and_include(parser, token):
    """
    Raises a deprecation warning about using the first argument. The
    remaining arguments are passed to an ``{% include %}`` tag. Usage::

        {% deprecate_and_include "old_template.html" "new_template.html" %}

    In order to avoid re-implementing {% include %} so as to resolve variables,
    this tag currently only works with literal template path strings.
    """
    split_contents = token.split_contents()
    current_template = split_contents[1]
    new_template = split_contents[2]
    if settings.DEBUG:
        warnings.simplefilter('always', DeprecationWarning)
    warnings.warn("The %s template is deprecated; Use %s instead." % (current_template, new_template), DeprecationWarning, stacklevel=2)
    new_contents = [split_contents[0]] + split_contents[2:]
    include_token = Token(token.token_type, " ".join(new_contents))

    return do_include(parser, include_token)


@register.filter
def sharedcontent_exists(slug):
    """
    Return `True` if shared content with the given slug name exists.

    This filter makes it possible to conditionally include shared content with
    surrounding markup only when the shared content item actually exits, and
    avoid outputting the surrounding markup when it doesn't.

    Example usage:

        {% load icekit_tags sharedcontent_tags %}

        {% if "shared-content-slug"|sharedcontent_exists %}
        <div class="surrounding-html">
            {% sharedcontent "shared-content-slug" %}
        </div>
        {% endif %}
    """
    from django.contrib.sites.models import Site
    from fluent_contents.plugins.sharedcontent.models import SharedContent
    site = Site.objects.get_current()
    return SharedContent.objects.parent_site(site).filter(slug=slug).exists()


@register.inclusion_tag(
    'icekit/navigation/navigation.html',
    name='render_navigation',
    takes_context=True,
)
def render_navigation(context, identifier):
    slug = slugify(identifier)
    navigation = navigation_models.Navigation.objects.filter(slug=slug).first()
    return {
        'navigation': navigation,
        'page': context.get('page'),
        'request': context.get('request'),
    }

