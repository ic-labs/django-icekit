# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('contenttypes', '0002_remove_content_type_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='EventContentListingItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, primary_key=True, to='fluent_contents.ContentItem', parent_link=True, auto_created=True)),
                ('limit', models.IntegerField(null=True, help_text=b'How many items to show? No limit is applied if this field is not set', blank=True)),
                ('content_type', models.ForeignKey(help_text=b'Content type of items to show in a listing', to='contenttypes.ContentType')),
            ],
            options={
                'db_table': 'contentitem_ik_event_listing_eventcontentlistingitem',
                'abstract': False,
                'verbose_name': 'Event Content Listing',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
