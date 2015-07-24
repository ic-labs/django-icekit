# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='TwitterEmbedItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('twitter_url', models.URLField(verbose_name='URL')),
                ('url', models.CharField(max_length=512, blank=True)),
                ('provider_url', models.CharField(max_length=512, blank=True)),
                ('cache_age', models.CharField(max_length=255, blank=True)),
                ('author_name', models.CharField(max_length=255, blank=True)),
                ('height', models.PositiveIntegerField(max_length=255, null=True, blank=True)),
                ('width', models.PositiveIntegerField(max_length=255, null=True, blank=True)),
                ('provider_name', models.CharField(max_length=255, blank=True)),
                ('version', models.CharField(max_length=20, blank=True)),
                ('author_url', models.CharField(max_length=255, blank=True)),
                ('type', models.CharField(max_length=50, blank=True)),
                ('html', models.TextField(blank=True)),
            ],
            options={
                'db_table': 'contentitem_twitter_embed_twitterembeditem',
                'verbose_name': 'Twitter Embed',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
