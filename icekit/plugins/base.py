from django.contrib.contenttypes.models import ContentType


class PluginMount(type):
    """
    Marty Alchin's Simple Plugin Framework.

    See: http://martyalchin.com/2008/jan/10/simple-plugin-framework/
    """

    def __init__(cls, name, bases, attrs):
        if not hasattr(cls, 'plugins'):
            # This branch only executes when processing the mount point itself.
            # So, since this is a new plugin type, not an implementation, this
            # class shouldn't be registered as a plugin. Instead, it sets up a
            # list where plugins can be registered later.
            cls.plugins = []
        else:
            # This must be a plugin implementation, which should be registered.
            # Simply appending it to the list is all that's needed to keep
            # track of it later.
            cls.plugins.append(cls)

    def get_plugins(cls, *args, **kwargs):
        """
        Return a list of plugin instances and pass through arguments.
        """
        return [plugin(*args, **kwargs) for plugin in cls.plugins]


class BaseChildModelPlugin(object):
    """
    Subclass and use ``PluginMount`` as a metaclass to create a new plugin pool
    for polymorphic child models.
    """

    model = None
    model_admin = None

    @property
    def content_type(self):
        """
        Return the ``ContentType`` for the model.
        """
        return ContentType.objects.get_for_model(self.model)

    @property
    def verbose_name(self):
        """
        Returns the title for the plugin, by default it reads the
        ``verbose_name`` of the model.
        """
        return self.model._meta.verbose_name
