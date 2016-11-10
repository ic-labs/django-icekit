# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_article', '0002_auto_20161019_1906'),
    ]

    operations = [
        migrations.AddField(
            model_name='article',
            name='boosted_search_terms',
            field=models.TextField(help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.', blank=True),
        ),
        migrations.AddField(
            model_name='article',
            name='list_image',
            field=models.ImageField(help_text=b"image to use in listings. Default image is used if this isn't given", upload_to=b'icekit/listable/list_image/', blank=True),
        ),
        migrations.AlterField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, verbose_name=b'Parent listing page', to='icekit_article.ArticleCategoryPage'),
        ),
    ]
