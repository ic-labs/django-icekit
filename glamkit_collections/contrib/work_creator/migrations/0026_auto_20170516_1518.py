# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0025_creatorbase_name_full'),
    ]

    operations = [
        migrations.AddField(
            model_name='creatorbase',
            name='dt_created',
            field=models.DateTimeField(default=datetime.datetime(2017, 5, 16, 5, 18, 19, 15118, tzinfo=utc), auto_now_add=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='dt_modified',
            field=models.DateTimeField(default=datetime.datetime(2017, 5, 16, 5, 18, 23, 487789, tzinfo=utc), auto_now=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='external_identifier',
            field=models.CharField(help_text=b'Unique identifier from an external system, such as from an external system from which records are imported.', max_length=255, null=True, blank=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='dt_created',
            field=models.DateTimeField(default=datetime.datetime(2017, 5, 16, 5, 18, 25, 610931, tzinfo=utc), auto_now_add=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='workbase',
            name='dt_modified',
            field=models.DateTimeField(default=datetime.datetime(2017, 5, 16, 5, 18, 27, 96606, tzinfo=utc), auto_now=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='workbase',
            name='external_identifier',
            field=models.CharField(help_text=b'Unique identifier from an external system, such as from an external system from which records are imported.', max_length=255, null=True, blank=True),
        ),
    ]
