# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0022_auto_20170622_1024'),
        ('icekit_events', '0029_fix_malformed_rrules_20170830_1101'),
        ('fluent_pages', '0001_initial'),
        ('icekit_plugins_location', '0005_auto_20170905_1136'),
        ('icekit', '0007_auto_20170310_1220'),
    ]

    operations = [
        migrations.CreateModel(
            name='AdvancedEventListingPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(auto_created=True, serialize=False, primary_key=True, parent_link=True, to='fluent_pages.UrlNode')),
                ('brief', models.TextField(help_text=b'A document brief describing the purpose of this content', blank=True)),
                ('admin_notes', models.TextField(help_text=b"Administrator's notes about this content", blank=True)),
                ('list_image', models.ImageField(upload_to=b'icekit/listable/list_image/', help_text=b"image to use in listings. Default image is used if this isn't given", blank=True)),
                ('boosted_search_terms', models.TextField(help_text='Words (space-separated) added here are boosted in relevance for search results increasing the chance of this appearing higher in the search results.', blank=True)),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(editable=False, null=True)),
                ('limit_to_home_locations', models.BooleanField(default=False)),
                ('default_start_date', models.DateField(blank=True, help_text=b"Default start date for event occurrences when the user has not selected a value. Leave empty to use today's date", null=True)),
                ('default_days_to_show', models.IntegerField(blank=True, help_text=b'Default period in days after the start date to show event occurrences when the user has not selected a value. Leave empty to use the value from Events setting  `appsettings.DEFAULT_DAYS_TO_SHOW`', null=True)),
                ('hero_image', models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, null=True, to='icekit_plugins_image.Image', blank=True, related_name='+', help_text=b'The hero image for this content.')),
                ('layout', models.ForeignKey(null=True, to='icekit.Layout', blank=True, related_name='advancedeventlisting_advancedeventlistingpage_related')),
                ('limit_to_locations', models.ManyToManyField(db_table=b'advanced_event_listing_page_locations', help_text=b'Leave empty to show all events.', to='icekit_plugins_location.Location', blank=True)),
                ('limit_to_primary_types', models.ManyToManyField(related_name='_advancedeventlistingpage_limit_to_primary_types_+', db_table=b'advanced_event_listing_page_primary_types', help_text=b'Leave empty to show all events.', to='icekit_events.EventType', blank=True)),
                ('limit_to_secondary_types', models.ManyToManyField(related_name='_advancedeventlistingpage_limit_to_secondary_types_+', db_table=b'advanced_event_listing_page_secondary_types', help_text=b'Leave empty to show all events.', to='icekit_events.EventType', blank=True)),
                ('publishing_linked', models.OneToOneField(on_delete=django.db.models.deletion.SET_NULL, null=True, to='advancedeventlisting.AdvancedEventListingPage', related_name='publishing_draft', editable=False)),
            ],
            options={
                'verbose_name': 'Advanced Event listing',
                'db_table': 'pagetype_advancedeventlisting_advancedeventlistingpage',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
