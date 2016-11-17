# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0003_auto_20161021_1441'),
        ('icekit_article', '0005_add_hero'),
    ]

    operations = [
        migrations.CreateModel(
            name='ArticleLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(auto_created=True, parent_link=True, primary_key=True, to='fluent_contents.ContentItem', serialize=False)),
                ('style', models.CharField(max_length=255, choices=[(b'', b'Small'), (b'large', b'Large')], blank=True, verbose_name='Link style')),
                ('type_override', models.CharField(max_length=255, blank=True)),
                ('title_override', models.CharField(max_length=255, blank=True)),
                ('image_override', models.ImageField(upload_to=b'icekit/listable/list_image/', blank=True)),
                ('oneliner_override', models.TextField(max_length=512, blank=True)),
                ('item', models.ForeignKey(to='icekit_article.Article')),
            ],
            options={
                'verbose_name': 'Article link',
                'db_table': 'contentitem_icekit_article_articlelink',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.AlterModelOptions(
            name='articlecategorypage',
            options={},
        ),
    ]
