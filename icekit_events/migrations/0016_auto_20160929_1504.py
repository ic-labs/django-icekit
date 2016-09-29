# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0015_auto_20160929_1308'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='derived_from',
            field=models.ForeignKey(related_name='derivitives', blank=True, editable=False, to='icekit_events.Event', null=True),
        ),
        migrations.AlterField(
            model_name='eventrepeatsgenerator',
            name='event',
            field=models.ForeignKey(related_name='repeat_generators', editable=False, to='icekit_events.Event'),
        ),
        migrations.AlterField(
            model_name='occurrence',
            name='event',
            field=models.ForeignKey(related_name='occurrences', editable=False, to='icekit_events.Event'),
        ),
    ]
