# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='AccountsNavigationItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(to='fluent_contents.ContentItem', auto_created=True, parent_link=True, primary_key=True, serialize=False)),
            ],
            options={
                'verbose_name': 'Accounts Navigation Item',
                'abstract': False,
                'db_table': 'contentitem_icekit_navigation_accountsnavigationitem',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='Navigation',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=255)),
                ('slug', models.SlugField()),
                ('pre_html', models.TextField(blank=True)),
                ('post_html', models.TextField(blank=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='NavigationItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(to='fluent_contents.ContentItem', auto_created=True, parent_link=True, primary_key=True, serialize=False)),
                ('title', models.CharField(max_length=255)),
                ('url', icekit.fields.ICEkitURLField(max_length=300)),
                ('html_class', models.CharField(blank=True, max_length=255)),
            ],
            options={
                'verbose_name': 'Navigation Item',
                'abstract': False,
                'db_table': 'contentitem_icekit_navigation_navigationitem',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
