from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem


@python_2_unicode_compatible
class AbstractFormItem(ContentItem):
    form = models.ForeignKey('forms.Form')

    class Meta:
        abstract = True
        verbose_name = _('Form')

    def __str__(self):
        return self.form.title
