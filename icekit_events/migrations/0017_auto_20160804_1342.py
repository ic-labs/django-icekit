# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0016_auto_20160803_1338'),
    ]

    operations = [
        migrations.AddField(
            model_name='event',
            name='publishing_is_draft',
            field=models.BooleanField(default=True, db_index=True, editable=False),
        ),
        migrations.AddField(
            model_name='event',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_events.Event'),
        ),
        migrations.AddField(
            model_name='event',
            name='publishing_modified_at',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='event',
            name='publishing_published_at',
            field=models.DateTimeField(null=True, editable=False),
        ),
    ]
