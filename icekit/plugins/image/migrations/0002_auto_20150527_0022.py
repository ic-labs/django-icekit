# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='imageitem',
            options={'verbose_name': 'Reusable image', 'verbose_name_plural': 'Reusable images'},
        ),
    ]
