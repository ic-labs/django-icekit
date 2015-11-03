from django.utils import six
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem
from icekit.utils import implementation


# Ensure django-brightcove dependency is installed.
try:
    from django_brightcove.fields import BrightcoveField
except ImportError:
    raise NotImplementedError(
        'Please install `django_brightcove` to use the `icekit.plugins.brightcove` plugin.'
    )

# Ensure required settings for django-brightcove have been defined.
implementation.check_settings(['BRIGHTCOVE_TOKEN', 'BRIGHTCOVE_PLAYER', ])


@python_2_unicode_compatible
class AbstractBrightcoveItem(ContentItem):
    """
    Media from brightcove.

    Brightcove is a video editing and management product which can be
    found at http://brightcove.com/.

    They have in built APIs and players.

    The BrightcoveField is a django specific implementation to allow
    the embedding of videos. It anticipates the video ID will be used
    as a lookup value.
    """
    video = BrightcoveField(
        help_text=_('Provide the video ID from the brightcove video.')
    )

    class Meta:
        abstract = True
        verbose_name = _('Brightcove video')
        verbose_name_plural = _('Brightcove videos')

    def __str__(self):
        return six.text_type(self.video)
