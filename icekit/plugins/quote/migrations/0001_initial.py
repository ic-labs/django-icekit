# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='QuoteItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('quote', models.TextField()),
                ('attribution', models.CharField(max_length=255, blank=True)),
            ],
            options={
                'db_table': 'contentitem_quote_quoteitem',
                'verbose_name': 'Quote',
                'verbose_name_plural': 'Quotes',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
