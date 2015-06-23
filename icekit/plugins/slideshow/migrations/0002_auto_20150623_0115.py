# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('slideshow', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='slideshowitem',
            options={'verbose_name': 'Slide show', 'verbose_name_plural': 'Slide shows'},
        ),
    ]
