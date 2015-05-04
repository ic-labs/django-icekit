# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.db.models.deletion
import django_brightcove.fields


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('django_brightcove', '__first__'),
    ]

    operations = [
        migrations.CreateModel(
            name='BrightcoveItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('video', django_brightcove.fields.BrightcoveField(on_delete=django.db.models.deletion.PROTECT, verbose_name='Brightcove', blank=True, to='django_brightcove.BrightcoveItems', null=True)),
            ],
            options={
                'db_table': 'contentitem_brightcove_brightcoveitem',
                'verbose_name': 'Brightcove Video',
                'verbose_name_plural': 'Brightcove Videos',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
