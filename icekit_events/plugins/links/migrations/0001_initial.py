# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0008_occurrence_external_ref'),
        ('fluent_contents', '0003_auto_20161021_1441'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(auto_created=True, parent_link=True, to='fluent_contents.ContentItem', primary_key=True, serialize=False)),
                ('style', models.CharField(blank=True, choices=[(b'', b'Small'), (b'large', b'Large')], verbose_name=b'Link style', max_length=255)),
                ('type_override', models.CharField(blank=True, max_length=255)),
                ('title_override', models.CharField(blank=True, max_length=255)),
                ('oneliner_override', models.CharField(blank=True, max_length=255)),
                ('url_override', icekit.fields.ICEkitURLField(blank=True, max_length=255)),
                ('image_override', models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/')),
                ('item', models.ForeignKey(to='icekit_events.EventBase')),
            ],
            options={
                'db_table': 'contentitem_icekit_events_links_eventlink',
                'verbose_name': 'Event link',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
