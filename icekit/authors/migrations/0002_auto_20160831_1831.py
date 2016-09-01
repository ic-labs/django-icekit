# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='author',
            options={'permissions': (('can_publish', 'Can publish'),)},
        ),
        migrations.AddField(
            model_name='author',
            name='publishing_is_draft',
            field=models.BooleanField(db_index=True, default=True, editable=False),
        ),
        migrations.AddField(
            model_name='author',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_authors.Author', null=True),
        ),
        migrations.AddField(
            model_name='author',
            name='publishing_modified_at',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='author',
            name='publishing_published_at',
            field=models.DateTimeField(null=True, editable=False),
        ),
    ]
