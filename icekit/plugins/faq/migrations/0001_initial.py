# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='FAQItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('question', models.TextField()),
                ('answer', models.TextField()),
                ('load_open', models.BooleanField(default=False)),
            ],
            options={
                'db_table': 'contentitem_faq_faqitem',
                'verbose_name': 'FAQ',
                'verbose_name_plural': 'FAQs',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
