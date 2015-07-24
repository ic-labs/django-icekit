# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('forms', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='FormItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('form', models.ForeignKey(to='forms.Form')),
            ],
            options={
                'db_table': 'contentitem_reusable_form_formitem',
                'verbose_name': 'Form',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
