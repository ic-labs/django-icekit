# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0003_auto_20161021_1441'),
        ('fluent_pages', '0001_initial'),
        ('layout_page', '0004_auto_20161110_1737'),
    ]

    operations = [
        migrations.CreateModel(
            name='PageLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, parent_link=True, auto_created=True, primary_key=True, to='fluent_contents.ContentItem')),
                ('style', models.CharField(blank=True, choices=[(b'', b'Small'), (b'large', b'Large')], verbose_name='Link style', max_length=255)),
                ('type_override', models.CharField(blank=True, max_length=255)),
                ('title_override', models.CharField(blank=True, max_length=255)),
                ('image_override', models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/')),
                ('oneliner_override', models.TextField(blank=True, max_length=512)),
                ('item', models.ForeignKey(to='fluent_pages.Page')),
            ],
            options={
                'verbose_name': 'Page link',
                'db_table': 'contentitem_layout_page_pagelink',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
