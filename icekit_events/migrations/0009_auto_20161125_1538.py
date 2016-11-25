# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0008_occurrence_external_ref'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventbase',
            name='external_ref',
            field=models.CharField(blank=True, help_text=b'The reference identifier used by an external events/tickets management system.', max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='eventbase',
            name='has_tickets_available',
            field=models.BooleanField(help_text=b'Check to show ticketing information', default=False),
        ),
    ]
