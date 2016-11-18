# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('fluent_pages', '0001_initial'),
        ('icekit_authors', '0003_auto_20161115_1118'),
        ('icekit_article', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ArticleLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(auto_created=True, serialize=False, to='fluent_contents.ContentItem', parent_link=True, primary_key=True)),
                ('style', models.CharField(blank=True, max_length=255, verbose_name=b'Link style', choices=[(b'', b'Small'), (b'large', b'Large')])),
                ('type_override', models.CharField(blank=True, max_length=255)),
                ('title_override', models.CharField(blank=True, max_length=255)),
                ('image_override', models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/')),
                ('item', models.ForeignKey(to='icekit_article.Article')),
            ],
            options={
                'db_table': 'contentitem_ik_links_articlelink',
                'verbose_name': 'Article link',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='AuthorLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(auto_created=True, serialize=False, to='fluent_contents.ContentItem', parent_link=True, primary_key=True)),
                ('style', models.CharField(blank=True, max_length=255, verbose_name=b'Link style', choices=[(b'', b'Small'), (b'large', b'Large')])),
                ('type_override', models.CharField(blank=True, max_length=255)),
                ('title_override', models.CharField(blank=True, max_length=255)),
                ('image_override', models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/')),
                ('item', models.ForeignKey(to='icekit_authors.Author')),
            ],
            options={
                'db_table': 'contentitem_ik_links_authorlink',
                'verbose_name': 'Author link',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='PageLink',
            fields=[
                ('contentitem_ptr', models.OneToOneField(auto_created=True, serialize=False, to='fluent_contents.ContentItem', parent_link=True, primary_key=True)),
                ('style', models.CharField(blank=True, max_length=255, verbose_name=b'Link style', choices=[(b'', b'Small'), (b'large', b'Large')])),
                ('type_override', models.CharField(blank=True, max_length=255)),
                ('title_override', models.CharField(blank=True, max_length=255)),
                ('image_override', models.ImageField(blank=True, upload_to=b'icekit/listable/list_image/')),
                ('item', models.ForeignKey(to='fluent_pages.Page')),
            ],
            options={
                'db_table': 'contentitem_ik_links_pagelink',
                'verbose_name': 'Page link',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
