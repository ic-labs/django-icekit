# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import timezone.timezone
import polymorphic_tree.models
import icekit_events.models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0012_auto_20160706_1606'),
    ]

    operations = [
        migrations.CreateModel(
            name='Occurrence',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('starts', models.DateTimeField(default=icekit_events.models.default_starts, db_index=True)),
                ('ends', models.DateTimeField(default=icekit_events.models.default_ends)),
                ('is_generated', models.BooleanField(default=False, db_index=True)),
                ('is_user_modified', models.BooleanField(default=False, db_index=True)),
                ('is_deleted', models.BooleanField(default=False)),
                ('is_hidden', models.BooleanField(default=False)),
                ('deleted_reason', models.CharField(max_length=255)),
                ('event', polymorphic_tree.models.PolymorphicTreeForeignKey(related_name='occurrences', editable=False, to='icekit_events.Event')),
            ],
            options={
                'ordering': ['starts'],
            },
        ),
    ]
