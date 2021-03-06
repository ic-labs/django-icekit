# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import fluent_contents.extensions


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='TextItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('text', fluent_contents.extensions.PluginHtmlField(verbose_name='text', blank=True)),
            ],
            options={
                'db_table': 'contentitem_text_textitem',
                'verbose_name': 'Text',
                'verbose_name_plural': 'Text',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
