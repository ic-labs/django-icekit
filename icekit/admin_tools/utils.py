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

def admin_link(inst, attr_string=""):
    """
    :param inst: An Model Instance
    :param attr_string: A string of attributes to be added to the <a> Tag.
    :return: a complete admin link for the instance. Permissions aren't checked.
    """

    # TODO: call with new window command, that adds new window icon and attr
    if inst:
        t = Template("""{% load admin_urls %}<a href="{% url opts|admin_urlname:'change' inst.pk %}" {{ attrs }}>Edit <em>{{ inst }}</em></a>""")
        return mark_safe(t.render(Context({ 'inst': inst, 'opts': inst._meta, 'attrs': attr_string})))
    return ""
