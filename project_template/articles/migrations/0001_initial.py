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
                ('id', models.AutoField(serialize=False, primary_key=True, auto_created=True, verbose_name='ID')),
                ('publishing_is_draft', models.BooleanField(db_index=True, default=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('layout', models.ForeignKey(related_name='glamkit_articles_article_related', blank=True, to='icekit.Layout', null=True)),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', to='glamkit_articles.Article', on_delete=django.db.models.deletion.SET_NULL, null=True, editable=False)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]
