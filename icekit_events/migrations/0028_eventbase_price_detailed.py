# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0027_auto_20170721_1613'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventbase',
            name='price_detailed',
            field=models.TextField(blank=True, help_text=b'A multi-line description of the price for this event. This is shown instead of the one-line price description if set'),
        ),
    ]
