# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
        ('tests', '0002_unpublishablelayoutpage'),
    ]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('layout', models.ForeignKey(related_name='tests_article_related', blank=True, to='icekit.Layout', null=True)),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='tests.Article')),
            ],
            options={
                'db_table': 'test_article',
            },
        ),
        migrations.CreateModel(
            name='LayoutPageWithRelatedPages',
            fields=[
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_pages.UrlNode')),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(related_name='tests_layoutpagewithrelatedpages_related', blank=True, to='icekit.Layout', null=True)),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='tests.LayoutPageWithRelatedPages')),
                ('related_pages', models.ManyToManyField(to='fluent_pages.Page')),
            ],
            options={
                'abstract': False,
                'db_table': 'test_layoutpage_with_related',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
