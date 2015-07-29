# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0005_remove_layout_key'),
    ]

    operations = [
        migrations.CreateModel(
            name='LayoutPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_pages.UrlNode')),
                ('layout', models.ForeignKey(related_name='layout_page_layoutpage_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'db_table': 'pagetype_layout_page_layoutpage',
                'verbose_name': 'Layout Page',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
