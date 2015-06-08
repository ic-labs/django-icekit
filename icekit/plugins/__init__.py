import operator

import six
from django.core.exceptions import ValidationError

from icekit import validators


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


class LayoutFieldChoicesPlugin(six.with_metaclass(PluginMount)):
    """
    Subclasses must accept a ``field`` argument (a ``LayoutField`` instance)
    and define a ``get_templates()`` method that returns a list of valid
    template names for the given field.
    """

    def __init__(self, field):
        self.field = field
        self.templates = self.get_templates() or []  # Make return optional.

    @classmethod
    def get_plugin_choices(cls, *args, **kwargs):
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


class DefaultLayoutFieldChoicesPlugin(LayoutFieldChoicesPlugin):

    def get_templates(self):
        """
        Return a list of default template names for the model:

            * ``{{ app }}/{{ model }}/layouts/default.html``
            * ``{{ app }}/layouts/default.html``
            * ``icekit/layouts/default.html``

        """
        meta = self.field.model._meta
        templates = [
            '{}/{}/layouts/default.html'.format(
                meta.app_label, meta.model_name),
            '{}/layouts/default.html'.format(meta.app_label),
            'icekit/layouts/default.html',
        ]
        return templates
