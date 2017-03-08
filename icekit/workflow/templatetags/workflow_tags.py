from django import template
from icekit.workflow.models import WorkflowState

register = template.Library()


class AssigedToUserNode(template.Node):
    def __init__(self, limit, varname, user):
        self.limit, self.varname, self.user = limit, varname, user

    def __repr__(self):
        return "<GetAssigedToUser Node>"

    def render(self, context):
        if self.user is None:
            context[self.varname] = WorkflowState.objects.all().select_related('content_type', 'user')[:self.limit]
        else:
            user_id = self.user
            if not user_id.isdigit():
                user_id = context[self.user].pk
            context[self.varname] = WorkflowState.objects.filter(
                assigned_to__pk=user_id,
            ).select_related('content_type')[:int(self.limit)]
        return ''


@register.tag
def get_assigned_to_user(parser, token):
    """
    Populates a template variable with the content with WorkflowState assignd
    for the given criteria.

    Usage::

        {% get_assigned_to_user [limit] as [varname] for_user [context_var_containing_user_obj] %}

    Examples::

        {% get_assigned_to_user 10 as content_list for_user 23 %}
        {% get_assigned_to_user 10 as content_list for_user user %}

    Note that ``context_var_containing_user_obj`` can be a hard-coded integer
    (user ID) or the name of a template context variable containing the user
    object whose ID you want.
    """
    tokens = token.contents.split()
    if len(tokens) < 4:
        raise template.TemplateSyntaxError(
            "'get_assigned_to_user' statements require two arguments")
    if not tokens[1].isdigit():
        raise template.TemplateSyntaxError(
            "First argument to 'get_assigned_to_user' must be an integer")
    if tokens[2] != 'as':
        raise template.TemplateSyntaxError(
            "Second argument to 'get_assigned_to_user' must be 'as'")
    if len(tokens) > 4:
        if tokens[4] != 'for_user':
            raise template.TemplateSyntaxError(
                "Fourth argument to 'get_assigned_to_user' must be 'for_user'")
    return AssigedToUserNode(limit=tokens[1], varname=tokens[3], user=(tokens[5] if len(tokens) > 5 else None))
