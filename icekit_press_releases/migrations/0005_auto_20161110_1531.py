# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_press_releases', '0004_auto_20160926_2341'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='contactitem',
            name='contact',
        ),
        migrations.RemoveField(
            model_name='contactitem',
            name='contentitem_ptr',
        ),
        migrations.DeleteModel(
            name='ContactItem',
        ),
        migrations.DeleteModel(
            name='PressContact',
        ),
    ]
