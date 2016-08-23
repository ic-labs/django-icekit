# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0005_imageitem_caption_override'),
    ]

    operations = [
        migrations.AlterField(
            model_name='image',
            name='categories',
            field=models.ManyToManyField(related_name='icekit_plugins_image_image_related', to='icekit.MediaCategory', blank=True),
            preserve_default=True,
        ),
        migrations.AlterModelTable(
            name='image',
            table=None,
        ),
        migrations.AlterModelTable(
            name='imageitem',
            table='contentitem_icekit_plugins_image_imageitem',
        ),
        migrations.RunSQL("UPDATE django_content_type SET app_label='icekit_plugins_image' WHERE app_label='image';"),
    ]
