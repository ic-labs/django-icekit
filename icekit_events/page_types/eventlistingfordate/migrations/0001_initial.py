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
                ('urlnode_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, to='fluent_pages.UrlNode', serialize=False)),
                ('publishing_is_draft', models.BooleanField(default=True, editable=False, db_index=True)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(editable=False, null=True)),
                ('layout', models.ForeignKey(blank=True, to='icekit.Layout', related_name='eventlistingfordate_eventlistingpage_related', null=True)),
                ('publishing_linked', models.OneToOneField(editable=False, on_delete=django.db.models.deletion.SET_NULL, to='eventlistingfordate.EventListingPage', related_name='publishing_draft', null=True)),
            ],
            options={
                'abstract': False,
                'verbose_name': 'Event Listing for Date',
                'db_table': 'pagetype_eventlistingfordate_eventlistingpage',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
