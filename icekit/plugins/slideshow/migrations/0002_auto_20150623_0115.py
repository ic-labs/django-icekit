# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_slideshow', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='slideshowitem',
            options={'verbose_name': 'Slide show', 'verbose_name_plural': 'Slide shows'},
        ),
        migrations.AlterModelTable(
            name='slideshow',
            table=None,
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_slideshow' WHERE app_label='slideshow';"
        ),
    ]
