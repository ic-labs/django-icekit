# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
        ('icekit_event_types_simple', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='simpleevent',
            name='layout',
            field=models.ForeignKey(related_name='icekit_event_types_simple_simpleevent_related', to='icekit.Layout', blank=True, null=True),
        ),
    ]
