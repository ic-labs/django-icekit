# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('search_page', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='searchpage',
            name='publishing_is_draft',
            field=models.BooleanField(default=True, db_index=True, editable=False),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='searchpage',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='search_page.SearchPage'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='searchpage',
            name='publishing_modified_at',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='searchpage',
            name='publishing_published_at',
            field=models.DateTimeField(null=True, editable=False),
            preserve_default=True,
        ),
    ]
