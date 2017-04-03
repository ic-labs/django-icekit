# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0010_auto_20170307_1458'),
    ]

    operations = [
        migrations.AlterField(
            model_name='image',
            name='image',
            field=icekit.fields.QuietImageField(width_field=b'width', upload_to=b'uploads/images/', height_field=b'height', verbose_name='Image file'),
        ),
        migrations.AlterField(
            model_name='image',
            name='is_ok_for_web',
            field=models.BooleanField(default=True, verbose_name='OK for web'),
        ),
    ]
