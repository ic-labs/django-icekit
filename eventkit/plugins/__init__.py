import six
from icekit.plugins.base import BaseChildModelPlugin, PluginMount


class EventPlugin(six.with_metaclass(PluginMount, BaseChildModelPlugin)):
    """
    Mount point for ``Event`` child model plugins.
    """
    pass
