# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0011_event_show_in_calendar'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='event',
            table=None,
        ),
        migrations.AlterModelTable(
            name='recurrencerule',
            table=None,
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_events' WHERE app_label='eventkit'",
            "",  # No-op
        ),
    ]
