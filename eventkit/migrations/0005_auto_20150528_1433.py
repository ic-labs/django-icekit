# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import timezone.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0004_auto_20150514_0002'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='created',
            field=models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='end_repeat',
            field=models.DateTimeField(help_text=b'If empty, this event will repeat indefinitely.', null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='event',
            name='modified',
            field=models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='recurrencerule',
            name='created',
            field=models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='recurrencerule',
            name='modified',
            field=models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True),
            preserve_default=True,
        ),
    ]
