"""
Validators for ``icekit`` app.
"""

from django.core.exceptions import ValidationError
from django.template import loader, TemplateDoesNotExist
from django.utils.translation import ugettext_lazy as _


def template_name(value):
    """
    Validate that a ``value`` is a valid template name.
    """
    try:
        loader.get_template(value)
    except TemplateDoesNotExist:
        raise ValidationError(
            _('Enter a valid template name.'), code='invalid')
