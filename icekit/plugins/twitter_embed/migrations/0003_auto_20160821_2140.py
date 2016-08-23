# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_twitter_embed', '0002_auto_20150724_0213'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='twitterembeditem',
            table='contentitem_icekit_plugins_twitter_embed_twitterembeditem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_twitter_embed' WHERE app_label='twitter_embed';"
        ),
    ]
