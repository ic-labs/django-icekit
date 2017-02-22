# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ik_event_listing', '0002_auto_20170222_1136'),
    ]

    operations = [
        migrations.AddField(
            model_name='eventcontentlistingitem',
            name='no_items_message',
            field=models.CharField(blank=True, help_text=b'Message to show if there are not items in listing.', null=True, max_length=255),
        ),
    ]
