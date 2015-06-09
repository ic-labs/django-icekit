# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0002_layout'),
        ('eventkit_fluentevent', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='fluentevent',
            name='layout',
            field=models.ForeignKey(related_name='eventkit_fluentevent_fluentevent_related', blank=True, to='icekit.Layout', null=True),
            preserve_default=True,
        ),
    ]
