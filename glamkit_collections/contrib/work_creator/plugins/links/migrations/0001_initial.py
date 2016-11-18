# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0003_auto_20161021_1441'),
        ('gk_collections_work_creator', '0008_auto_20161114_1240'),
    ]

    operations = [
        migrations.CreateModel(
            name='CreatorLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(primary_key=True, to='fluent_contents.ContentItem', serialize=False, parent_link=True, auto_created=True)),
                ('style', models.CharField(blank=True, choices=[(b'', b'Small'), (b'large', b'Large')], verbose_name=b'Link style', max_length=255)),
                ('type_override', models.CharField(blank=True, max_length=255)),
                ('title_override', models.CharField(blank=True, max_length=255)),
                ('url_override', icekit.fields.ICEkitURLField(blank=True, max_length=255)),
                ('image_override', models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/')),
                ('item', models.ForeignKey(to='gk_collections_work_creator.CreatorBase')),
            ],
            options={
                'verbose_name': 'Creator link',
                'db_table': 'contentitem_gk_collections_links_creatorlink',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='WorkLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(primary_key=True, to='fluent_contents.ContentItem', serialize=False, parent_link=True, auto_created=True)),
                ('style', models.CharField(blank=True, choices=[(b'', b'Small'), (b'large', b'Large')], verbose_name=b'Link style', max_length=255)),
                ('type_override', models.CharField(blank=True, max_length=255)),
                ('title_override', models.CharField(blank=True, max_length=255)),
                ('url_override', icekit.fields.ICEkitURLField(blank=True, max_length=255)),
                ('image_override', models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/')),
                ('item', models.ForeignKey(to='gk_collections_work_creator.WorkBase')),
            ],
            options={
                'verbose_name': 'Work link',
                'db_table': 'contentitem_gk_collections_links_worklink',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
