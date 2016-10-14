# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0018_auto_20160929_2106'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='eventpage',
            name='event_ptr',
        ),
        migrations.DeleteModel(
            name='EventPage',
        ),
    ]
