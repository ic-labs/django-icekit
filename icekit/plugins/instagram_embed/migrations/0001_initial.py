# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='InstagramEmbedItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('url', models.URLField()),
                ('provider_url', models.CharField(max_length=512, blank=True)),
                ('media_id', models.CharField(max_length=255, blank=True)),
                ('author_name', models.CharField(max_length=255, blank=True)),
                ('height', models.PositiveIntegerField(max_length=255, null=True, blank=True)),
                ('width', models.PositiveIntegerField(max_length=255, null=True, blank=True)),
                ('thumbnail_url', models.CharField(max_length=255, blank=True)),
                ('thumbnail_width', models.PositiveIntegerField(max_length=255, null=True, blank=True)),
                ('thumbnail_height', models.PositiveIntegerField(max_length=255, null=True, blank=True)),
                ('provider_name', models.CharField(max_length=255, blank=True)),
                ('title', models.CharField(max_length=512, blank=True)),
                ('html', models.TextField(blank=True)),
                ('version', models.CharField(max_length=20, blank=True)),
                ('author_url', models.CharField(max_length=255, blank=True)),
                ('author_id', models.PositiveIntegerField(max_length=255, null=True, blank=True)),
                ('type', models.CharField(max_length=50, blank=True)),
            ],
            options={
                'db_table': 'contentitem_instagram_embed_instagramembeditem',
                'verbose_name': 'Instagram Embed',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
