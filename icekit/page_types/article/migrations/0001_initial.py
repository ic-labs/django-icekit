# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.AutoField(auto_created=True, serialize=False, verbose_name='ID', primary_key=True)),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('layout', models.ForeignKey(related_name='icekit_article_article_related', blank=True, null=True, to='icekit.Layout')),
            ],
        ),
        migrations.CreateModel(
            name='ArticleCategoryPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(serialize=False, primary_key=True, auto_created=True, parent_link=True, to='fluent_pages.UrlNode')),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(related_name='icekit_article_articlecategorypage_related', blank=True, null=True, to='icekit.Layout')),
                ('publishing_linked', models.OneToOneField(null=True, related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_article.ArticleCategoryPage')),
            ],
            options={
                'db_table': 'pagetype_icekit_article_articlecategorypage',
                'abstract': False,
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
        migrations.AddField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='icekit_article.ArticleCategoryPage'),
        ),
        migrations.AddField(
            model_name='article',
            name='publishing_linked',
            field=models.OneToOneField(null=True, related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_article.Article'),
        ),
        migrations.AlterUniqueTogether(
            name='article',
            unique_together=set([('slug', 'parent', 'publishing_linked')]),
        ),
    ]
