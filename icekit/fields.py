from django import forms
from django.db import models
from django.utils import six
from django.utils.translation import ugettext_lazy as _
from icekit.validators import RelativeURLValidator

from . import validators


class TemplateNameField(six.with_metaclass(models.SubfieldBase, models.CharField)):
    """
    A validated template name. If a ``plugin_class`` is given, which should be
    a ``TemplateNameFieldChoicesPlugin`` subclass, choices will be provided by
    any registered plugins.
    """

    default_validators = [validators.template_name]
    description = _('Template name')

    def __init__(self, *args, **kwargs):
        self.plugin_class = kwargs.pop('plugin_class', None)
        if self.plugin_class:
            # Force the admin to recognise that this field has choices, even
            # though we don't know what they are until runtime.
            kwargs.setdefault('choices', [('', '')])
        # Use the max `max_length` by default. Template names can be long.
        kwargs.setdefault('max_length', 255)
        super(TemplateNameField, self).__init__(*args, **kwargs)

    def formfield(self, **kwargs):
        """
        Get choices from plugins, if necessary.
        """
        if self.plugin_class:
            self._choices = self.plugin_class.get_all_choices(field=self)
        return super(TemplateNameField, self).formfield(**kwargs)


class ICEkitURLField(models.URLField):
    default_validators = [RelativeURLValidator(verify_exists=True)]
    description = _("URL")

    def formfield(self, **kwargs):
        # skip the URLfield's formfield() as it repeats the validation.
        return models.CharField.formfield(self, **kwargs)
