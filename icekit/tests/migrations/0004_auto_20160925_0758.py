# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
        ('fluent_pages', '0001_initial'),
        ('tests', '0003_auto_20160810_2054'),
    ]

    operations = [
        migrations.CreateModel(
            name='ArticleListing',
            fields=[
                ('urlnode_ptr', models.OneToOneField(serialize=False, primary_key=True, auto_created=True, parent_link=True, to='fluent_pages.UrlNode')),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(related_name='tests_articlelisting_related', blank=True, null=True, to='icekit.Layout')),
                ('publishing_linked', models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='tests.ArticleListing')),
            ],
            options={
                'db_table': 'test_articlelisting',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
        migrations.AddField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(to='tests.ArticleListing', default=1),
            preserve_default=False,
        ),
    ]
