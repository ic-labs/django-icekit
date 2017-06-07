# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit_press_releases', '0002_auto_20160810_1832'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='pressreleaselisting',
            name='layout',
        ),
        migrations.RemoveField(
            model_name='pressreleaselisting',
            name='publishing_linked',
        ),
        migrations.RemoveField(
            model_name='pressreleaselisting',
            name='urlnode_ptr',
        ),
        migrations.DeleteModel(
            name='PressReleaseListing',
        ),
    ]
