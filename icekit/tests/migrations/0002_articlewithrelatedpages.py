# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
        ('tests', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ArticleWithRelatedPages',
            fields=[
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_pages.UrlNode')),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(related_name='tests_articlewithrelatedpages_related', blank=True, to='icekit.Layout', null=True)),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='tests.ArticleWithRelatedPages')),
                ('related_pages', models.ManyToManyField(to='fluent_pages.Page')),
            ],
            options={
                'db_table': 'test_article_with_related',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
