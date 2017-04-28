# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0009_auto_20161026_2044'),
        ('tests', '0005_auto_20161027_1428'),
    ]

    operations = [
        migrations.AddField(
            model_name='articlelisting',
            name='boosted_search_terms',
            field=models.TextField(help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.', blank=True),
        ),
        migrations.AddField(
            model_name='articlelisting',
            name='hero_image',
            field=models.ForeignKey(null=True, related_name='+', to='icekit_plugins_image.Image', help_text=b'The hero image for this content.', blank=True),
        ),
        migrations.AddField(
            model_name='articlelisting',
            name='list_image',
            field=models.ImageField(upload_to=b'icekit/listable/list_image/', help_text=b"image to use in listings. Default image is used if this isn't given", blank=True),
        ),
        migrations.AddField(
            model_name='layoutpagewithrelatedpages',
            name='boosted_search_terms',
            field=models.TextField(help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.', blank=True),
        ),
        migrations.AddField(
            model_name='layoutpagewithrelatedpages',
            name='hero_image',
            field=models.ForeignKey(null=True, related_name='+', to='icekit_plugins_image.Image', help_text=b'The hero image for this content.', blank=True),
        ),
        migrations.AddField(
            model_name='layoutpagewithrelatedpages',
            name='list_image',
            field=models.ImageField(upload_to=b'icekit/listable/list_image/', help_text=b"image to use in listings. Default image is used if this isn't given", blank=True),
        ),
    ]
