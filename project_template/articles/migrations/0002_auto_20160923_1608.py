# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
        ('glamkit_articles', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ArticleCategoryPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(auto_created=True, parent_link=True, to='fluent_pages.UrlNode', serialize=False, primary_key=True)),
                ('publishing_is_draft', models.BooleanField(db_index=True, default=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(null=True, to='icekit.Layout', blank=True, related_name='glamkit_articles_articlecategorypage_related')),
                ('publishing_linked', models.OneToOneField(editable=False, null=True, to='glamkit_articles.ArticleCategoryPage', related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL)),
            ],
            options={
                'db_table': 'pagetype_glamkit_articles_articlecategorypage',
                'abstract': False,
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
        migrations.RemoveField(
            model_name='articlecategory',
            name='layout',
        ),
        migrations.RemoveField(
            model_name='articlecategory',
            name='publishing_linked',
        ),
        migrations.RemoveField(
            model_name='articlecategory',
            name='urlnode_ptr',
        ),
        migrations.AlterField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(null=True, to='glamkit_articles.ArticleCategoryPage', blank=True),
        ),
        migrations.DeleteModel(
            name='ArticleCategory',
        ),
    ]
