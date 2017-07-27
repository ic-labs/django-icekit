# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0022_auto_20170622_1024'),
        ('icekit_plugins_location', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='location',
            name='boosted_search_terms',
            field=models.TextField(help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.', blank=True),
        ),
        migrations.AddField(
            model_name='location',
            name='hero_image',
            field=models.ForeignKey(blank=True, null=True, related_name='+', help_text=b'The hero image for this content.', to='icekit_plugins_image.Image', on_delete=django.db.models.deletion.SET_NULL),
        ),
        migrations.AddField(
            model_name='location',
            name='list_image',
            field=models.ImageField(help_text=b"image to use in listings. Default image is used if this isn't given", blank=True, upload_to=b'icekit/listable/list_image/'),
        ),
    ]
