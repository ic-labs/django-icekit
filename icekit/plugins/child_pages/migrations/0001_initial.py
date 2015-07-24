# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ChildPageItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
            ],
            options={
                'db_table': 'contentitem_child_pages_childpageitem',
                'verbose_name': 'Child Page',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
