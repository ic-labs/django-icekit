"""
Models for ``icekit`` app.
"""

# Compose concrete models from abstract models and mixins, to facilitate reuse.

import six
from django.db import models
from django.utils import encoding, timezone
from django.utils.translation import ugettext_lazy as _

from icekit import plugins, validators


# FIELDS ######################################################################


class LayoutField(
        six.with_metaclass(models.SubfieldBase, models.CharField)):
    """
    A Django template name that can provide layout and placeholder data to
    models that use `django-fluent-contents`. In forms, a ``ChoiceField`` is
    used, with choices provided by ``LayoutFieldChoicesPlugin`` subclasses.
    """

    default_validators = [validators.template_name]
    description = _('Name of a template providing layout and placeholder data')

    def __init__(self, *args, **kwargs):
        self.plugin_class = kwargs.pop(
            'plugin_class', plugins.LayoutFieldChoicesPlugin)
        # Force the admin to recognise that this field has choices, even though
        # we don't know what they are until runtime.
        kwargs.setdefault('choices', [('', '')])
        # Use the max `max_length` by default. Template names can be long.
        kwargs.setdefault('max_length', 255)
        super(LayoutField, self).__init__(*args, **kwargs)

    def formfield(self, **kwargs):
        """
        Get choices from plugins.
        """
        self._choices = self.plugin_class.get_plugin_choices(field=self)
        return super(LayoutField, self).formfield(**kwargs)


# MODELS ######################################################################


class AbstractBaseModel(models.Model):
    """
    Abstract base model.
    """

    created = models.DateTimeField(
        default=timezone.now, db_index=True, editable=False)
    modified = models.DateTimeField(
        default=timezone.now, db_index=True, editable=False)

    class Meta:
        abstract = True
        get_latest_by = 'pk'
        ordering = ('-id', )

    def save(self, *args, **kwargs):
        """
        Update ``self.modified``.
        """
        self.modified = timezone.now()
        super(AbstractBaseModel, self).save(*args, **kwargs)


@encoding.python_2_unicode_compatible
class MediaCategory(AbstractBaseModel):
    """
    A categorisation model for Media assets.
    """
    name = models.CharField(
        max_length=255,
        unique=True,
    )

    class Meta:
        verbose_name_plural = 'Media categories'

    def __str__(self):
        return self.name
