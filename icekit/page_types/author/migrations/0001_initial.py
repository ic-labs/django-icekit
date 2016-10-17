# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.validators
import django.utils.timezone
import fluent_contents.extensions
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0008_auto_20160920_2114'),
        ('icekit', '0006_auto_20150911_0744'),
        ('fluent_pages', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Author',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, verbose_name='ID', serialize=False)),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(editable=False, null=True)),
                ('given_name', models.CharField(max_length=255)),
                ('family_name', models.CharField(blank=True, max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('url', models.CharField(blank=True, validators=[icekit.validators.RelativeURLValidator()], max_length=255, help_text='The URL for the authors website.')),
                ('introduction', fluent_contents.extensions.PluginHtmlField(verbose_name='introduction', help_text='An introduction about the author used on list pages.')),
                ('portrait', models.ForeignKey(blank=True, to='icekit_plugins_image.Image', null=True)),
                ('publishing_linked', models.OneToOneField(to='icekit_authors.Author', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='publishing_draft', editable=False)),
            ],
            options={
                'ordering': ('family_name', 'given_name'),
            },
        ),
        migrations.CreateModel(
            name='AuthorListing',
            fields=[
                ('urlnode_ptr', models.OneToOneField(to='fluent_pages.UrlNode', primary_key=True, auto_created=True, parent_link=True, serialize=False)),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(editable=False, null=True)),
                ('layout', models.ForeignKey(blank=True, to='icekit.Layout', null=True, related_name='icekit_authors_authorlisting_related')),
                ('publishing_linked', models.OneToOneField(to='icekit_authors.AuthorListing', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='publishing_draft', editable=False)),
            ],
            options={
                'verbose_name': 'Author listing',
                'db_table': 'pagetype_icekit_authors_authorlisting',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
