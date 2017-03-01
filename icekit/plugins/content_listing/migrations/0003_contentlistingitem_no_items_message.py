# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_content_listing', '0002_contentlistingitem_limit'),
    ]

    operations = [
        migrations.AddField(
            model_name='contentlistingitem',
            name='no_items_message',
            field=models.CharField(help_text=b'Message to show if there are not items in listing.', max_length=255, null=True, blank=True),
        ),
    ]
