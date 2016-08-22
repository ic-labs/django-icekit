# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_instagram_embed', '0003_auto_20150724_0213'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='instagramembeditem',
            table='contentitem_icekit_plugins_instagram_embed_instagramembeditem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_instagram_embed' WHERE app_label='instagram_embed';"
        ),
    ]
