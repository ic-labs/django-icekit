# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django_countries.fields
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0008_auto_20160920_2114'),
        ('icekit', '0006_auto_20150911_0744'),
        ('contenttypes', '0002_remove_content_type_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='CreatorBase',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True, auto_created=True, verbose_name='ID')),
                ('list_image', models.ImageField(upload_to=b'icekit/listable/list_image/', blank=True, help_text=b"image to use in listings. Default image is used if this isn't given")),
                ('boosted_search_terms', models.TextField(blank=True, help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.')),
                ('publishing_is_draft', models.BooleanField(db_index=True, default=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('name_display', models.CharField(max_length=255, help_text=b'The commonly known or generally recognized name of the creator, for display, publication and reproduction purposes, e.g., "Rembrandt" or "Guercino" as opposed to the full name "Rembrandt Harmenszoon Van Rijn" or "Giovanni Francesco Barbieri."')),
                ('slug', models.CharField(db_index=True, max_length=255)),
                ('alt_slug', models.SlugField(max_length=255, blank=True)),
                ('website', models.CharField(max_length=255, blank=True)),
                ('wikipedia_link', models.URLField(blank=True, help_text=b"e.g. 'https://en.wikipedia.org/wiki/Pablo_Picasso'")),
                ('admin_notes', models.TextField(blank=True)),
                ('name_sort', models.CharField(max_length=255, help_text=b'For searching and organizing, the name or sequence of names which determines the position of the creator in the list of creators, so that he or she may be found where expected, e.g. "Rembrandt" under "R" or "Guercino" under "G"')),
                ('layout', models.ForeignKey(to='icekit.Layout', null=True, blank=True, related_name='gk_collections_work_creator_creatorbase_related')),
                ('polymorphic_ctype', models.ForeignKey(to='contenttypes.ContentType', editable=False, null=True, related_name='polymorphic_gk_collections_work_creator.creatorbase_set+')),
                ('portrait', models.ForeignKey(to='icekit_plugins_image.Image', null=True, blank=True)),
                ('publishing_linked', models.OneToOneField(to='gk_collections_work_creator.CreatorBase', editable=False, null=True, related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL)),
            ],
            options={
                'ordering': ('name_sort',),
                'verbose_name': 'creator',
            },
        ),
        migrations.CreateModel(
            name='Role',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True, auto_created=True, verbose_name='ID')),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('past_tense', models.CharField(max_length=255, help_text=b"If the role is 'foundry', the past tense should be 'forged'. Use lower case.")),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='WorkBase',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True, auto_created=True, verbose_name='ID')),
                ('list_image', models.ImageField(upload_to=b'icekit/listable/list_image/', blank=True, help_text=b"image to use in listings. Default image is used if this isn't given")),
                ('boosted_search_terms', models.TextField(blank=True, help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.')),
                ('publishing_is_draft', models.BooleanField(db_index=True, default=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('slug', models.CharField(db_index=True, max_length=255)),
                ('alt_slug', models.SlugField(max_length=255, blank=True)),
                ('title', models.CharField(max_length=255, help_text=b'The official title of this object. Includes series title when appropriate.')),
                ('date_display', models.CharField(max_length=255, verbose_name=b'Date (display)', blank=True, help_text=b'Displays date as formatted for labels and reports, rather than sorting.')),
                ('date_edtf', models.CharField(max_length=64, blank=True, verbose_name=b'Date (EDTF)', null=True, help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, as best as we could parse from the display date, e.g. '1855/1860-06-04'")),
                ('origin_continent', models.CharField(max_length=255, blank=True)),
                ('origin_country', django_countries.fields.CountryField(max_length=2, blank=True)),
                ('origin_state_province', models.CharField(max_length=255, blank=True)),
                ('origin_city', models.CharField(max_length=255, blank=True)),
                ('origin_neighborhood', models.CharField(max_length=255, blank=True)),
                ('origin_colloquial', models.CharField(max_length=255, blank=True, help_text=b'The colloquial or historical name of the place at the time of the object\'s creation, e.g., "East Bay"')),
                ('credit_line', models.TextField(blank=True, help_text=b'A formal public credit statement about a transfer of ownership, acquisition, source, or sponsorship of an item suitable for use in a display, label or publication')),
                ('thumbnail_override', models.ImageField(blank=True, upload_to=b'', null=True, help_text='An optional override to use when the work is displayed at thumbnail dimensions')),
                ('accession_number', models.CharField(max_length=255, blank=True, help_text=b'The five components of the Accession number concatenated  in a single string for efficiency of display and retrieval.')),
                ('website', models.URLField(blank=True, help_text=b'A URL at which to view this work, if available online')),
                ('wikipedia_link', models.URLField(blank=True, help_text=b"e.g. 'https://en.wikipedia.org/wiki/Beauty_and_the_Beast_(2014_film)'")),
                ('admin_notes', models.TextField(blank=True)),
            ],
            options={
                'verbose_name': 'work',
            },
        ),
        migrations.CreateModel(
            name='WorkCreator',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True, auto_created=True, verbose_name='ID')),
                ('order', models.PositiveIntegerField(help_text=b'Which order to show this creator in the list of all creators')),
                ('is_primary', models.BooleanField(default=True)),
                ('creator', models.ForeignKey(to='gk_collections_work_creator.CreatorBase')),
                ('role', models.ForeignKey(to='gk_collections_work_creator.Role', null=True, blank=True)),
                ('work', models.ForeignKey(to='gk_collections_work_creator.WorkBase')),
            ],
            options={
                'ordering': ('order',),
            },
        ),
        migrations.AddField(
            model_name='workbase',
            name='creators',
            field=models.ManyToManyField(related_name='works', to='gk_collections_work_creator.CreatorBase', through='gk_collections_work_creator.WorkCreator'),
        ),
        migrations.AddField(
            model_name='workbase',
            name='layout',
            field=models.ForeignKey(to='icekit.Layout', null=True, blank=True, related_name='gk_collections_work_creator_workbase_related'),
        ),
        migrations.AddField(
            model_name='workbase',
            name='polymorphic_ctype',
            field=models.ForeignKey(to='contenttypes.ContentType', editable=False, null=True, related_name='polymorphic_gk_collections_work_creator.workbase_set+'),
        ),
        migrations.AddField(
            model_name='workbase',
            name='publishing_linked',
            field=models.OneToOneField(to='gk_collections_work_creator.WorkBase', editable=False, null=True, related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL),
        ),
        migrations.AlterUniqueTogether(
            name='workcreator',
            unique_together=set([('creator', 'work', 'role')]),
        ),
        migrations.AlterUniqueTogether(
            name='workbase',
            unique_together=set([('slug', 'publishing_is_draft')]),
        ),
        migrations.AlterUniqueTogether(
            name='creatorbase',
            unique_together=set([('slug', 'publishing_is_draft')]),
        ),
    ]
