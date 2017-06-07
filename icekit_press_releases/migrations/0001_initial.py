# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import timezone.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.CreateModel(
            name='ContactItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
            ],
            options={
                'db_table': 'contentitem_icekit_press_releases_contactitem',
                'verbose_name': 'Contact Item',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='PressContact',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=255)),
                ('title', models.CharField(max_length=255)),
                ('phone', models.CharField(max_length=255)),
                ('email', models.EmailField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='PressRelease',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('print_version', models.FileField(null=True, upload_to=b'press-releases/downloads/', blank=True)),
                ('created', models.DateTimeField(default=timezone.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(db_index=True, null=True, blank=True)),
                ('released', models.DateTimeField(db_index=True, null=True, blank=True)),
            ],
            options={
                'ordering': ('-released',),
            },
        ),
        migrations.CreateModel(
            name='PressReleaseCategory',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='PressReleaseListing',
            fields=[
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_pages.UrlNode')),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(related_name='icekit_press_releases_pressreleaselisting_related', blank=True, to='icekit.Layout', null=True)),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_press_releases.PressReleaseListing')),
            ],
            options={
                'abstract': False,
                'db_table': 'pagetype_icekit_press_releases_pressreleaselisting',
                'verbose_name': 'Layout Page',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
        migrations.AddField(
            model_name='pressrelease',
            name='category',
            field=models.ForeignKey(blank=True, to='icekit_press_releases.PressReleaseCategory', null=True),
        ),
        migrations.AddField(
            model_name='pressrelease',
            name='layout',
            field=models.ForeignKey(related_name='icekit_press_releases_pressrelease_related', blank=True, to='icekit.Layout', null=True),
        ),
        migrations.AddField(
            model_name='pressrelease',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_press_releases.PressRelease'),
        ),
        migrations.AddField(
            model_name='contactitem',
            name='contact',
            field=models.ForeignKey(to='icekit_press_releases.PressContact'),
        ),
    ]
