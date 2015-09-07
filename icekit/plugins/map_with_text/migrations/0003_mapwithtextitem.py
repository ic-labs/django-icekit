# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import fluent_contents.extensions


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('map_with_text', '0002_auto_20150906_2301'),
    ]

    operations = [
        migrations.CreateModel(
            name='MapWithTextItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('share_url', models.URLField(help_text=b'Share URL sourced from Google Maps. See https://support.google.com/maps/answer/144361?hl=en', max_length=500, verbose_name=b'Share URL')),
                ('text', fluent_contents.extensions.PluginHtmlField(verbose_name='text', blank=True)),
                ('map_on_right', models.BooleanField(default=False, verbose_name='Map side', choices=[(False, b'Map on left'), (True, b'Map on right')])),
            ],
            options={
                'abstract': False,
                'db_table': 'contentitem_map_with_text_mapwithtextitem',
                'verbose_name': 'Google Map with Text',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
