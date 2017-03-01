# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ContentListingItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, to='fluent_contents.ContentItem', parent_link=True, primary_key=True, auto_created=True)),
                ('content_type', models.ForeignKey(to='contenttypes.ContentType', help_text=b'Content type of items to show in a listing')),
            ],
            options={
                'verbose_name': 'Content Listing',
                'db_table': 'contentitem_icekit_plugins_content_listing_contentlistingitem',
                'abstract': False,
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
