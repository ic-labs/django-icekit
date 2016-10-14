# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
        ('fluent_pages', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True, auto_created=True, verbose_name='ID')),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(to='icekit.Layout', related_name='icekit_articles_article_related', null=True, blank=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='ArticleCategoryPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(to='fluent_pages.UrlNode', primary_key=True, auto_created=True, parent_link=True, serialize=False)),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(to='icekit.Layout', related_name='icekit_articles_articlecategorypage_related', null=True, blank=True)),
                ('publishing_linked', models.OneToOneField(to='icekit_articles.ArticleCategoryPage', null=True, editable=False, related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL)),
            ],
            options={
                'db_table': 'pagetype_icekit_articles_articlecategorypage',
                'abstract': False,
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
        migrations.AddField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(to='icekit_articles.ArticleCategoryPage'),
        ),
        migrations.AddField(
            model_name='article',
            name='publishing_linked',
            field=models.OneToOneField(to='icekit_articles.Article', null=True, editable=False, related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL),
        ),
    ]
