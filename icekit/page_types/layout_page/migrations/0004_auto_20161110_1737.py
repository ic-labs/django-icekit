# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0009_auto_20161026_2044'),
        ('layout_page', '0003_auto_20160810_1856'),
    ]

    operations = [
        migrations.AddField(
            model_name='layoutpage',
            name='boosted_search_terms',
            field=models.TextField(help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.', blank=True),
        ),
        migrations.AddField(
            model_name='layoutpage',
            name='hero_image',
            field=models.ForeignKey(null=True, related_name='+', blank=True, to='icekit_plugins_image.Image', help_text=b'The hero image for this content.'),
        ),
        migrations.AddField(
            model_name='layoutpage',
            name='list_image',
            field=models.ImageField(help_text=b"image to use in listings. Default image is used if this isn't given", blank=True, upload_to=b'icekit/listable/list_image/'),
        ),
    ]
