# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.CreateModel(
            name='AuthorListing',
            fields=[
                ('urlnode_ptr', models.OneToOneField(serialize=False, auto_created=True, to='fluent_pages.UrlNode', primary_key=True, parent_link=True)),
                ('publishing_is_draft', models.BooleanField(default=True, db_index=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(related_name='page_authorlisting_related', blank=True, null=True, to='icekit.Layout')),
                ('publishing_linked', models.OneToOneField(editable=False, related_name='publishing_draft', on_delete=django.db.models.deletion.SET_NULL, to='self', null=True)),
            ],
            options={
                'db_table': 'pagetype_page_authorlisting',
                'verbose_name': 'Author landing page',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
