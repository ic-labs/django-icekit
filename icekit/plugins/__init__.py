import six

from icekit.plugins.base import (
    BaseTemplateNameFieldChoicesPlugin, TemplateNameFieldChoicesPluginMount)


# PLUGIN MOUNT POINTS #########################################################

# Subclass a mount point to register create a plugin and register it with the
# mount point.


class TemplateNameFieldChoicesPlugin(six.with_metaclass(
        TemplateNameFieldChoicesPluginMount,
        BaseTemplateNameFieldChoicesPlugin)):
    """
    Mount point for template name choices plugins.
    """

    def __init__(self, field):
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


# PLUGINS #####################################################################


class DefaultLayoutTemplatesPlugin(TemplateNameFieldChoicesPlugin):

    def get_templates(self):
        """
        Return a list of default template names for the model and app on which
        the ``TemplateNameField`` is declared:

            * ``{{ app }}/{{ model }}/layouts/default.html``
            * ``{{ app }}/layouts/default.html``

        """
        templates = []
        for related_object in self.field.model._meta.get_all_related_objects():
            # Django 1.8 deprecated `get_all_related_objects()`. We're still
            # using it for now with the documented work-around for
            # compatibility with Django <=1.7.
            model = getattr(
                related_object, 'related_model', related_object.model)
            templates.extend([
                '{}/{}/layouts/default.html'.format(
                    model._meta.app_label, model._meta.model_name),
                '{}/layouts/default.html'.format(model._meta.app_label),
            ])
        return templates


class ICEkitLayoutPlugin(TemplateNameFieldChoicesPlugin):

    def get_templates(self):
        """
        Return the default ICEkit layout template, to be sure there is always
        at least one layout template available.
        """
        return ['icekit/layouts/default.html']
