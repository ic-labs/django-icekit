import six
from icekit.plugins.base import BaseChildModelPlugin, PluginMount


class EventChildModelPlugin(six.with_metaclass(
        PluginMount, BaseChildModelPlugin)):
    """
    Mount point for ``Event`` child model plugins.
    """
    pass
