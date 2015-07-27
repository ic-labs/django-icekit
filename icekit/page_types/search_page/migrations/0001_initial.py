# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='SearchPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_pages.UrlNode')),
            ],
            options={
                'db_table': 'pagetype_search_page_searchpage',
                'verbose_name': 'Search Page',
            },
            bases=('fluent_pages.htmlpage',),
        ),
    ]
