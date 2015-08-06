# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone
import django_extensions.db.fields


class Migration(migrations.Migration):

    dependencies = [
        ('image', '0003_auto_20150623_0115'),
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ContentCategory',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=255)),
                ('is_active', models.BooleanField(default=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Location',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(help_text='City or gallery.', max_length=255)),
                ('google_map', models.URLField(help_text='Optional. If a Google Maps Share URL is supplied a hyperlink will be rendered to it.', max_length=500, blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Post',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', django_extensions.db.fields.CreationDateTimeField(default=django.utils.timezone.now, verbose_name='created', editable=False, blank=True)),
                ('modified', django_extensions.db.fields.ModificationDateTimeField(default=django.utils.timezone.now, verbose_name='modified', editable=False, blank=True)),
                ('event_start', models.DateField()),
                ('event_end', models.DateField()),
                ('title', models.CharField(help_text='The title of the post', max_length=255, blank=True)),
                ('slug', django_extensions.db.fields.AutoSlugField(populate_from=b'title', editable=False, blank=True)),
                ('intro', models.TextField(help_text='Optional, otherwise a truncated selection of the body will be displayed', blank=True)),
                ('body', models.TextField()),
                ('is_active', models.BooleanField(default=True)),
                ('admin_notes', models.TextField(help_text='Internal notes for administrators only.', blank=True)),
                ('category', models.ForeignKey(to='blog.ContentCategory')),
                ('location', models.ForeignKey(blank=True, to='blog.Location', null=True)),
                ('photo', models.ForeignKey(to='image.Image')),
            ],
            options={
                'ordering': ('-created',),
                'verbose_name': 'Blog Post',
                'verbose_name_plural': 'Blog Posts',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='PostItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('post', models.ForeignKey(help_text='A blog post (unpublished items will not be visible to the public)', to='blog.Post')),
            ],
            options={
                'db_table': 'contentitem_blog_postitem',
                'verbose_name': 'Blog Post',
                'verbose_name_plural': 'Blog Posts',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
