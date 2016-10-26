# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import fluent_contents.plugins.oembeditem.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_game', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='game',
            name='trailer',
            field=fluent_contents.plugins.oembeditem.fields.OEmbedUrlField(help_text='Enter the URL of the online content to embed (e.g. a YouTube or Vimeo video, SlideShare presentation, etc..)', blank=True),
        ),
    ]
