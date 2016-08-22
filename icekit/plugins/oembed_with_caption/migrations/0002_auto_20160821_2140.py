# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_oembed_with_caption', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='oembedwithcaptionitem',
            table='contentitem_icekit_plugins_oembed_with_caption_oembedwithcad412',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_oembed_with_caption' WHERE app_label='oembed_with_caption';"
        ),
    ]
