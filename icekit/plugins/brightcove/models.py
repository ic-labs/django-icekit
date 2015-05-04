from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


try:
    from django_brightcove.fields import BrightcoveField
except ImportError:
    raise NotImplementedError(
        _(
            'Please install `django_brightcove`to use the icekit.plugins.brightcove plugin.'
        )
    )


@python_2_unicode_compatible
class BrightcoveItem(ContentItem):
    """
    Media from brightcove.

    Brightcove is a video editing and management product which can be
    found at http://brightcove.com/.

    They have in built APIs and players.

    The BrightcoveField is a django specific implementation to allow
    the embedding of videos. It anticipates the video ID will be used
    as a lookup value.

    In the template to be rendered you will need to include:
    <script
        type="text/javascript"
        src="http://admin.brightcove.com/js/BrightcoveExperiences.js"
    >
    </script>
    """
    video = BrightcoveField(
        help_text=_('Provide the video ID from the brightcove video.')
    )

    class Meta:
        verbose_name = _('Brightcove Video')
        verbose_name_plural = _('Brightcove Videos')

    def __str__(self):
        return str(self.video)
