# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventListingPage',
            fields=[
                ('urlnode_ptr', models.OneToOneField(to='fluent_pages.UrlNode', serialize=False, primary_key=True, parent_link=True, auto_created=True)),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(related_name='glamkit_events_eventlistingpage_related', to='icekit.Layout', blank=True, null=True)),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL, to='glamkit_events.EventListingPage', null=True, editable=False)),
            ],
            options={
                'db_table': 'pagetype_glamkit_events_eventlistingpage',
                'verbose_name': 'Event Listing',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
