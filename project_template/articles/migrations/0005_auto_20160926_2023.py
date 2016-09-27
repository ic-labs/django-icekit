# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
        ('contenttypes', '0002_remove_content_type_name'),
        ('glamkit_articles', '0004_auto_20160926_1946'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='article',
            name='layout',
        ),
        migrations.CreateModel(
            name='LayoutArticle',
            fields=[
                ('article_ptr', models.OneToOneField(primary_key=True, auto_created=True, parent_link=True, serialize=False, to='glamkit_articles.Article')),
                ('layout', models.ForeignKey(related_name='glamkit_articles_layoutarticle_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'abstract': False,
            },
            bases=('glamkit_articles.article', models.Model),
        ),
        migrations.CreateModel(
            name='RedirectArticle',
            fields=[
                ('article_ptr', models.OneToOneField(primary_key=True, auto_created=True, parent_link=True, serialize=False, to='glamkit_articles.Article')),
            ],
            options={
                'abstract': False,
            },
            bases=('glamkit_articles.article',),
        ),
        migrations.AddField(
            model_name='article',
            name='polymorphic_ctype',
            field=models.ForeignKey(related_name='polymorphic_glamkit_articles.article_set+', editable=False, to='contenttypes.ContentType', null=True),
        ),
    ]
