# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0008_auto_20151208_2213'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='date_end_repeat',
            field=models.DateField(help_text='If empty, this event will repeat indefinitely.', null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='end_repeat',
            field=models.DateTimeField(help_text='If empty, this event will repeat indefinitely.', null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='ends',
            field=models.DateTimeField(null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='starts',
            field=models.DateTimeField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
