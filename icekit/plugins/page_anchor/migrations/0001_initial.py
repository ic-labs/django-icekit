# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='PageAnchorItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('anchor_name', models.CharField(max_length=60)),
            ],
            options={
                'db_table': 'contentitem_page_anchor_pageanchoritem',
                'verbose_name': 'Page Anchor',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
