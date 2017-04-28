from django.template import Template, Context
from django.utils.safestring import mark_safe


def admin_url(inst):
    """
    :param inst: An Model Instance
    :return: the admin URL for the instance. Permissions aren't checked.
    """
    if inst:
        t = Template("""{% load admin_urls %}{% url opts|admin_urlname:'change' inst.pk %}""")
        return t.render(Context({ 'inst': inst, 'opts': inst._meta}))
    return ""

def admin_link(inst, attr_string="target=\"_blank\"", inner_html=""):
    """
    :param inst: An Model Instance
    :param attr_string: A string of attributes to be added to the <a> Tag.
    :param inner_html: Override html inside the <a> Tag.
    :return: a complete admin link for the instance. Permissions aren't checked.
    """

    # TODO: call with new window command, that adds new window icon and attr
    if inst:
        t = Template("""{% load admin_urls %}<a title="Edit '{{ inst }}'" href="{% url opts|admin_urlname:'change' inst.pk %}" {{ attr_string|safe }}>{% if inner_html %}{{ inner_html|safe }}{% else %}Edit <em>{{ inst }}</em>{% endif %}</a>""")
        return mark_safe(t.render(Context({ 'inst': inst, 'opts': inst._meta, 'attr_string': attr_string, 'inner_html': inner_html})))
    return ""
