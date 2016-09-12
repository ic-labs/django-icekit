# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import fluent_contents.extensions


class Migration(migrations.Migration):

    replaces = [(b'icekit_plugins_map_with_text', '0001_initial'), (b'icekit_plugins_map_with_text', '0002_auto_20150906_2301'), (b'icekit_plugins_map_with_text', '0003_mapwithtextitem')]

    dependencies = [
        ('icekit_plugins_map', '0001_initial'),
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='MapWithTextItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(primary_key=True, parent_link=True, to='fluent_contents.ContentItem', serialize=False, auto_created=True)),
                ('share_url', models.URLField(verbose_name=b'Share URL', max_length=500, help_text=b'Share URL sourced from Google Maps. See https://support.google.com/maps/answer/144361?hl=en')),
                ('text', fluent_contents.extensions.PluginHtmlField(verbose_name='text', blank=True)),
                ('map_on_right', models.BooleanField(choices=[(False, b'Map on left'), (True, b'Map on right')], verbose_name='Map side', default=False)),
            ],
            options={
                'verbose_name': 'Google Map with Text',
                'db_table': 'contentitem_map_with_text_mapwithtextitem',
                'abstract': False,
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
