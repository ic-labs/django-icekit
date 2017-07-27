# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0022_auto_20170622_1024'),
        ('icekit_event_types_simple', '0003_auto_20161125_1701'),
    ]

    operations = [
        migrations.AddField(
            model_name='simpleevent',
            name='boosted_search_terms',
            field=models.TextField(blank=True, help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.'),
        ),
        migrations.AddField(
            model_name='simpleevent',
            name='hero_image',
            field=models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, to='icekit_plugins_image.Image', help_text=b'The hero image for this content.', blank=True, related_name='+', null=True),
        ),
        migrations.AddField(
            model_name='simpleevent',
            name='list_image',
            field=models.ImageField(upload_to=b'icekit/listable/list_image/', blank=True, help_text=b"image to use in listings. Default image is used if this isn't given"),
        ),
    ]
