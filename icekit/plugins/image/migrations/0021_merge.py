# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import icekit
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0020_auto_20170317_1655'),
        ('icekit_plugins_image', '0011_auto_20170310_1220'),
    ]

    operations = [
        migrations.AlterField(
            model_name='image',
            name='image',
            field=icekit.fields.QuietImageField(verbose_name='Image file',
                                                upload_to=b'uploads/images/',
                                                height_field=b'height',
                                                width_field=b'width'),
        ),
        migrations.AlterField(
            model_name='image',
            name='is_ok_for_web',
            field=models.BooleanField(verbose_name='OK for web', default=True),
        ),
    ]
