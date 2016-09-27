# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
        ('fluent_pages', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.AutoField(serialize=False, verbose_name='ID', primary_key=True, auto_created=True)),
                ('publishing_is_draft', models.BooleanField(default=True, editable=False, db_index=True)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(editable=False, null=True)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('layout', models.ForeignKey(blank=True, related_name='glamkit_articles_article_related', to='icekit.Layout', null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='ArticleCategory',
            fields=[
                ('urlnode_ptr', models.OneToOneField(primary_key=True, parent_link=True, to='fluent_pages.UrlNode', serialize=False, auto_created=True)),
                ('publishing_is_draft', models.BooleanField(default=True, editable=False, db_index=True)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(editable=False, null=True)),
                ('layout', models.ForeignKey(blank=True, related_name='glamkit_articles_articlecategory_related', to='icekit.Layout', null=True)),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', to='glamkit_articles.ArticleCategory', on_delete=django.db.models.deletion.SET_NULL, null=True, editable=False)),
            ],
            options={
                'db_table': 'pagetype_glamkit_articles_articlecategory',
                'abstract': False,
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
        migrations.AddField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(blank=True, to='glamkit_articles.ArticleCategory', null=True),
        ),
        migrations.AddField(
            model_name='article',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', to='glamkit_articles.Article', on_delete=django.db.models.deletion.SET_NULL, null=True, editable=False),
        ),
    ]
