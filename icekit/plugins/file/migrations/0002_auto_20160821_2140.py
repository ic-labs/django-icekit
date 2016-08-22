# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_file', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='file',
            name='categories',
            field=models.ManyToManyField(related_name='icekit_plugins_file_file_related', to='icekit.MediaCategory', blank=True),
        ),
        migrations.AlterModelTable(
            name='file',
            table=None,
        ),
        migrations.AlterModelTable(
            name='fileitem',
            table='contentitem_icekit_plugins_file_fileitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_file' WHERE app_label='file';"
        ),
    ]
