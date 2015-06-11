import operator

from django.contrib.contenttypes.models import ContentType
from django.core.exceptions import ValidationError

from icekit import validators


# METACLASSES #################################################################

# When these are used as a metaclass for a plugin mount point, each plugin
# subclass will register itself the mount point. Attributes and methods defined
# on a these metaclasses will become class methods on plugin mount points.

# To iterate plugin classes, access the `plugins` attribute on the mount point.
# To iterate plugin instances, call the `get_plugins()` method on the mount
# point. Any arguments will be passed through to each plugin subclass.


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


class TemplateNameFieldChoicesPluginMount(PluginMount):
    """
    Add ``get_all_choices()`` method.
    """

    def get_all_choices(cls, *args, **kwargs):
        """
        Validate (template), de-duplicate (by template), sort (by label) and
        return a list of `(template, label)` choices for all plugins.
        """
        plugins = cls.get_plugins(*args, **kwargs)
        all_choices = reduce(operator.add, [
            plugin.get_choices() for plugin in plugins
        ])
        choices = []
        seen = set()
        for template, label in all_choices:
            # De-duplicate.
            if template in seen:
                continue
            seen.add(template)
            # Validate.
            try:
                validators.template_name(template)
            except ValidationError:
                continue
            choices.append((template, label))
        # Sort by label.
        choices = sorted(choices, lambda a, b: cmp(a[1], b[1]))
        return choices


# BASE PLUGIN MOUNT POINTS ####################################################

# When these are used as base classes along with a plugin mount metaclass,
# the resulting plugin mount will have these attributes and methods.


class BaseChildModelPlugin(object):
    """
    Subclass with a ``PluginMount`` metaclass to create a new plugin mount
    point for polymorphic child models.
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


class BaseTemplateNameFieldChoicesPlugin(object):
    """
    Subclass with a ``PluginMount`` metaclass to create a new plugin mount
    point for a template name field.
    """

    def __init__(self, field):
        """
        Set ``field`` and ``templates`` attributes, with an empty list for
        templates by default to make a return optional in the
        ``get_templates()`` method of plugin classes.
        """
        self.field = field
        self.templates = self.get_templates() or []  # Make return optional.

    def get_choices(self):
        """
        Return a list of ``(value, label)`` choices for ``self.templates``,
        with the template name as both the value and label.
        """
        return [(template, template) for template in self.templates]

    def get_templates(self):
        """
        Return a list of template names.
        """
        raise NotImplemented
