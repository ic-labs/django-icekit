import os

import six

from icekit import appsettings
from icekit.plugins.base import (
    BaseTemplateNameFieldChoicesPlugin, TemplateNameFieldChoicesPluginMount)


# PLUGIN MOUNT POINTS #########################################################

# Subclass a mount point to create and register a plugin with the mount point.


class TemplateNameFieldChoicesPlugin(six.with_metaclass(
        TemplateNameFieldChoicesPluginMount,
        BaseTemplateNameFieldChoicesPlugin)):
    """
    Mount point for template name choices plugins.
    """
    pass


# PLUGINS #####################################################################


class AppModelDefaultLayoutsPlugin(TemplateNameFieldChoicesPlugin):

    def get_choices(self):
        """
        Return a list of choices for default app and app/model template names:

            * ``{{ app }}/{{ model }}/layouts/default.html``
            * ``{{ app }}/layouts/default.html``

        """
        choices = []
        for related_object in self.field.model._meta.get_all_related_objects():
            # Django 1.8 deprecated `get_all_related_objects()`. We're still
            # using it for now with the documented work-around for
            # compatibility with Django <=1.7.
            meta = getattr(
                related_object, 'related_model', related_object.model)._meta
            # App default.
            template_name = '%s/layouts/default.html' % meta.app_label
            label = '%s: Default' % meta.app_config.verbose_name
            choices.append((template_name, label))
            # Model default.
            template_name = '%s/%s/layouts/default.html' % (
                meta.app_label,
                meta.model_name,
            )
            label = '%s: %s' % (
                meta.app_config.verbose_name,
                meta.verbose_name.capitalize(),
            )
            choices.append((template_name, label))
        return choices


class FileSystemLayoutsPlugin(TemplateNameFieldChoicesPlugin):
    """
    Source layout templates from one or more directories on the file system.

    Directories can be specified in the ``ICEKIT['LAYOUT_TEMPLATES']`` setting,
    which should be a list of 3-tuples, each containing a label prefix, a
    templates directory that will be searched by the installed template
    loaders, and a template name prefix.

    The templates directory and template name prefix are combined to get the
    source directory. All files in this directory will be included.

    The template name prefix and the source file path, relative to the source
    directory, are combined to get the template name.

    The label prefix and source file path are combined to get the label.

    Given the following directory structure::

        /myproject/templates/myproject/layouts/foo.html
        /myproject/templates/myproject/layouts/bar/baz.html

    These settings::

        ICEKIT = {
            'LAYOUT_TEMPLATES': (
                ('My Project', '/myproject/templates, 'myproject/layouts'),
            ),
        }

    Would result in these choices::

        ('myproject/layouts/foo.html', 'My Project: foo.html')
        ('myproject/layouts/bar/baz.html', 'My Project: bar/baz.html')

    """

    def get_choices(self):
        """
        Return a list of choices for source files found in configured layout
        template directories.
        """
        choices = []
        for label_prefix, templates_dir, template_name_prefix in \
                appsettings.LAYOUT_TEMPLATES:
            source_dir = os.path.join(templates_dir, template_name_prefix)
            # Walk directories, appending a choice for each source file.
            for local, dirs, files in os.walk(source_dir, followlinks=True):
                for source_file in files:
                    template_name = os.path.join(
                        template_name_prefix, source_file)
                    label = '%s: %s' % (label_prefix, source_file)
                    choices.append((template_name, label))
        return choices


class ICEkitLayoutPlugin(TemplateNameFieldChoicesPlugin):

    def get_choices(self):
        """
        Return the default ICEkit layout template, to be sure there is always
        at least one layout template available.
        """
        choices = [
            ('icekit/layouts/default.html', 'ICEkit: Default'),
        ]
        return choices
