# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Quote',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('quote', models.TextField()),
                ('attribution', models.CharField(max_length=255, blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ReusableQuoteItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('quote', models.ForeignKey(help_text='An quote from the quote library.', to='reusable_quote.Quote')),
            ],
            options={
                'db_table': 'contentitem_reusable_quote_reusablequoteitem',
                'verbose_name': 'Quote',
                'verbose_name_plural': 'Quotes',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
