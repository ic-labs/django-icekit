# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0005_auto_20161024_1742'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='occurrence',
            options={'ordering': ['start_date', 'start', 'event__title', 'pk']},
        ),
        migrations.AddField(
            model_name='occurrence',
            name='end_date',
            field=models.DateField(default=datetime.datetime(2016, 11, 1, 3, 19, 41, 815314, tzinfo=utc), db_index=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='occurrence',
            name='original_end_date',
            field=models.DateField(null=True, editable=False, blank=True),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='original_start_date',
            field=models.DateField(null=True, editable=False, blank=True),
        ),
        migrations.AddField(
            model_name='occurrence',
            name='start_date',
            field=models.DateField(default=datetime.datetime(2016, 11, 1, 3, 19, 45, 647055, tzinfo=utc), db_index=True),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='occurrence',
            name='end',
            field=models.DateTimeField(db_index=True, null=True, blank=True),
        ),
        migrations.AlterField(
            model_name='occurrence',
            name='start',
            field=models.DateTimeField(db_index=True, null=True, blank=True),
        ),
    ]
