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
    pass
