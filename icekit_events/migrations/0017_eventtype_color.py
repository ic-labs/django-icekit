# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import colorful.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0016_auto_20161208_0030'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventtype',
            name='color',
            field=colorful.fields.RGBColorField(default=b'#cccccc'),
        ),
    ]
