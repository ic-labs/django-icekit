import os
from django.db import models
from django.template.defaultfilters import filesizeformat
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import ContentItem
from icekit import appsettings


@python_2_unicode_compatible
class AbstractFile(models.Model):
    """
    A reusable file.
    """
    file = models.FileField(
        upload_to='uploads/files/',
        verbose_name=_('File field'),
    )
    title = models.CharField(
        max_length=255,
        blank=True,
    )
    is_active = models.BooleanField(
        default=True,
    )
    categories = models.ManyToManyField(
        'icekit.MediaCategory',
        blank=True,
        related_name='%(app_label)s_%(class)s_related',
    )
    admin_notes = models.TextField(
        blank=True,
        help_text=_('Internal notes for administrators only.'),
    )

    class Meta:
        abstract = True

    def __str__(self):
        return self.title or os.path.basename(self.file.name).split('.')[0]

    def file_size(self):
        """
        Obtain the file size for the file in human readable format.

        :return: String of file size with unit.
        """
        return filesizeformat(self.file.size)

    def extension(self):
        """
        Obtain the extension for the file.

        :return: String.
        """
        file_name_and_extension_list = self.file.name.split('.')
        if len(file_name_and_extension_list) > 1:
            return file_name_and_extension_list[-1]
        return ''


@python_2_unicode_compatible
class AbstractFileItem(ContentItem):
    """
    A file from the File model.
    """
    file = models.ForeignKey(
        appsettings.FILE_CLASS,
        help_text=_('A file from the file library.')
    )

    class Meta:
        abstract = True
        verbose_name = _('File')
        verbose_name_plural = _('Files')

    def __str__(self):
        return str(self.file)
