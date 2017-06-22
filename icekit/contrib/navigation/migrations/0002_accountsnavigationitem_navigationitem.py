# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('icekit_contrib_navigation', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='AccountsNavigationItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, auto_created=True, primary_key=True, parent_link=True, to='fluent_contents.ContentItem')),
            ],
            options={
                'db_table': 'contentitem_icekit_contrib_navigation_accountsnavigationitem',
                'abstract': False,
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='NavigationItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, auto_created=True, primary_key=True, parent_link=True, to='fluent_contents.ContentItem')),
                ('title', models.CharField(max_length=255)),
                ('url', icekit.fields.ICEkitURLField(max_length=300)),
                ('html_class', models.CharField(max_length=255, blank=True)),
            ],
            options={
                'db_table': 'contentitem_icekit_contrib_navigation_navigationitem',
                'abstract': False,
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
