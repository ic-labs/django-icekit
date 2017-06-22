from django.template import Library
from django.utils.text import slugify
from icekit.contrib.navigation.models import Navigation

register = Library()


@register.inclusion_tag(
    'icekit/contrib/navigation/navigation.html',
    name='render_navigation',
    takes_context=True,
)
def render_navigation(context, identifier):
    navigation, _ = Navigation.objects.get_or_create(
        slug=slugify(identifier),
        defaults={'name': identifier},
    )
    return {
        'navigation': navigation,
        'page': context.get('page'),
        'request': context.get('request'),
    }

