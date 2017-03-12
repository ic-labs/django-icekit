import logging

from any_urlfield.forms import SimpleRawIdWidget
from any_urlfield.models import AnyUrlField
from any_urlfield.registry import UrlTypeRegistry
from django.conf import settings
from django.db import models
from django.utils import six
from django.utils.translation import ugettext_lazy as _
from fluent_pages.models import Page
from django.db.models import ImageField

from . import validators


logger = logging.getLogger(__name__)


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


class ICEkitURLField(AnyUrlField):
    # start with an empty UrlTypeRegistry to undo Fluent_Page's
    # inappropriate-for-us restriction to only-published Pages.
    _static_registry = UrlTypeRegistry()

    @classmethod
    def register_model_once(cls, ModelClass, **kwargs):
        """
        Tweaked version of `AnyUrlField.register_model` that only registers the
        given model after checking that it is not already registered.
        """
        if cls._static_registry.get_for_model(ModelClass) is None:
            logger.warn("Model is already registered with {0}: '{1}'"
                        .format(cls, ModelClass))
        else:
            cls.register_model.register(ModelClass, **kwargs)


class QuietImageField(ImageField):
    """An imagefield that doesn't lose the plot when trying to find the
    dimensions of an image that doesn't exist"""

    def update_dimension_fields(self, *args, **kwargs):
        try:
            super(QuietImageField, self).update_dimension_fields(
                *args, **kwargs)
        except IOError:
            pass


# (Re-)Register Fluent's Page model in our fresh subclass,
# only this time using the default (unpublished) queryset.
if 'fluent_pages' in settings.INSTALLED_APPS:
    ICEkitURLField.register_model(Page, widget=SimpleRawIdWidget(Page))
