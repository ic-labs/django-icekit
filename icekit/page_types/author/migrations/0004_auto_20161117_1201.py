# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0003_auto_20161115_1118'),
    ]

    operations = [
        migrations.AddField(
            model_name='author',
            name='boosted_search_terms',
            field=models.TextField(blank=True, help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.'),
        ),
        migrations.AddField(
            model_name='author',
            name='list_image',
            field=models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/', help_text=b"image to use in listings. Default image is used if this isn't given"),
        ),
    ]
