# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
        ('tests', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='UnpublishableLayoutPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_pages.UrlNode')),
                ('layout', models.ForeignKey(related_name='tests_unpublishablelayoutpage_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'abstract': False,
                'db_table': 'pagetype_tests_unpublishablelayoutpage',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
