# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_page_types_article', '0002_auto_20160622_1959'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='articlepage',
            options={'verbose_name': 'Article Page', 'permissions': (('change_page_layout', 'Can change Page layout'),)},
        ),
        migrations.AddField(
            model_name='articlepage',
            name='publishing_is_draft',
            field=models.BooleanField(default=True, db_index=True, editable=False),
        ),
        migrations.AddField(
            model_name='articlepage',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_page_types_article.ArticlePage'),
        ),
        migrations.AddField(
            model_name='articlepage',
            name='publishing_modified_at',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='articlepage',
            name='publishing_published_at',
            field=models.DateTimeField(null=True, editable=False),
        ),
    ]
