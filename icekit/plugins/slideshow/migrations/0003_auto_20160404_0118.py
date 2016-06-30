# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('slideshow', '0002_auto_20150623_0115'),
    ]

    operations = [
        migrations.AddField(
            model_name='slideshow',
            name='publishing_is_draft',
            field=models.BooleanField(default=True, db_index=True, editable=False),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='slideshow',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='slideshow.SlideShow'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='slideshow',
            name='publishing_modified_at',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='slideshow',
            name='publishing_published_at',
            field=models.DateTimeField(null=True, editable=False),
            preserve_default=True,
        ),
    ]
