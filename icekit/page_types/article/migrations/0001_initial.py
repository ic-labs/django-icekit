# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0003_layout_content_types'),
        ('fluent_pages', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ArticlePage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_pages.UrlNode')),
                ('layout', models.ForeignKey(related_name=b'articles_articlepage_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'db_table': 'pagetype_article_articlepage',
                'verbose_name': 'Article',
                'permissions': (('change_page_layout', 'Can change Page layout'),),
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
