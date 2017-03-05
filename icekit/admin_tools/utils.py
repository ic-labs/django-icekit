from django.contrib.admin.templatetags.admin_urls import admin_urlname
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

def admin_link(inst):
    """
    :param inst: An Model Instance
    :return: a complete admin link for the instance. Permissions aren't checked.
    """
    if inst:
        t = Template("""{% load admin_urls %}<a href="{% url opts|admin_urlname:'change' inst.pk %}">Edit <em>{{ inst }}</em></a>""")
        return mark_safe(t.render(Context({ 'inst': inst, 'opts': inst._meta})))
    return ""
