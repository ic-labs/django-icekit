from django.db import models
from . import abstract_models


class BrightcoveItem(abstract_models.AbstractBrightcoveItem):
    """
    Media from brightcove.

    Brightcove is a video editing and management product which can be
    found at http://brightcove.com/.

    They have in built APIs and players.

    The BrightcoveField is a django specific implementation to allow
    the embedding of videos. It anticipates the video ID will be used
    as a lookup value.
    """

    is_full_width = models.BooleanField(default=False)
    is_four_three = models.BooleanField(default=False, help_text='Does this video have a 4:3 ratio?')

    pass
