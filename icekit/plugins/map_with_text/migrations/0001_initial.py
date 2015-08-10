# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import fluent_contents.extensions


class Migration(migrations.Migration):

    dependencies = [
        ('map', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='MapWithTextItem',
            fields=[
                ('mapitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='map.MapItem')),
                ('text', fluent_contents.extensions.PluginHtmlField(verbose_name='text', blank=True)),
                ('map_on_right', models.BooleanField(default=False, verbose_name='Map side', choices=[(False, b'Map on left'), (True, b'Map on right')])),
            ],
            options={
                'db_table': 'contentitem_map_with_text_mapwithtextitem',
                'verbose_name': 'Google Map with Text',
            },
            bases=('map.mapitem',),
        ),
    ]
