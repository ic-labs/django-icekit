# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True, serialize=False)),
                ('publishing_is_draft', models.BooleanField(editable=False, default=True, db_index=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(editable=False, null=True)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('layout', models.ForeignKey(blank=True, to='icekit.Layout', null=True, related_name='articles_article_related')),
                ('publishing_linked', models.OneToOneField(editable=False, on_delete=django.db.models.deletion.SET_NULL, to='articles.Article', null=True, related_name='publishing_draft')),
            ],
            options={
                'abstract': False,
            },
        ),
    ]
