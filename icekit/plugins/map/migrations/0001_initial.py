# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='MapItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('share_url', models.URLField(help_text=b'Share URL sourced from Google Maps. See https://support.google.com/maps/answer/144361?hl=en', max_length=500, verbose_name=b'Share URL')),
            ],
            options={
                'db_table': 'contentitem_map_mapitem',
                'verbose_name': 'Google Map',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
