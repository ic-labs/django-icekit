# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import icekit.models


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit_fluentevent', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='fluentevent',
            name='layout',
            field=icekit.models.LayoutField(default=b'eventkit_fluentevent/layouts/default.html', max_length=255, choices=[(b'', b'')]),
            preserve_default=True,
        ),
    ]
