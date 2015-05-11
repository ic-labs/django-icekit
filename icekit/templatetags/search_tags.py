from django.template import Library, Node
from django.test.client import RequestFactory


register = Library()
factory = RequestFactory()


class FakeRequestNode(Node):
    def render(self, context):
        req = factory.get('/')
        req.notifications = []
        context['request'] = req

        return ''

@register.tag
def fake_request(parser, token):
    """
    Create a fake request object in the context
    """
    return FakeRequestNode()

