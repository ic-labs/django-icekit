# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import fluent_contents.extensions


class FakeCreateModel(migrations.CreateModel):
    def database_forwards(self, app_label, schema_editor, from_state, to_state):
        pass

    def database_backwards(self, app_label, schema_editor, from_state, to_state):
        pass


class Migration(migrations.Migration):

    dependencies = [
        ('map_with_text', '0005_auto_20150903_1948'),
    ]

    operations = [
        FakeCreateModel(
            name='MapWithTextItem',
            fields=[
                ('mapitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('share_url_new', models.URLField(help_text=b'Share URL sourced from Google Maps. See https://support.google.com/maps/answer/144361?hl=en', max_length=500, verbose_name=b'Share URL')),
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
