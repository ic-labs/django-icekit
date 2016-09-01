# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
        ('icekit_authors_page', '0002_auto_20160901_1905'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='AuthorListing',
            new_name="AuthorsPage"
        )
    ]
