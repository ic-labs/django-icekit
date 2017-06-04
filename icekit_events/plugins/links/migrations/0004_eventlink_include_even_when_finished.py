# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events_links', '0003_auto_20170511_1909'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventlink',
            name='include_even_when_finished',
            field=models.BooleanField(help_text=b'Show this link even when the event has finished.', default=False),
        ),
    ]
