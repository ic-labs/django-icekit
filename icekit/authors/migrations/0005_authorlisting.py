# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
        ('fluent_pages', '0001_initial'),
        ('icekit_authors', '0004_auto_20160901_1743'),
    ]

    operations = [
        migrations.CreateModel(
            name='AuthorListing',
            fields=[
                ('urlnode_ptr', models.OneToOneField(primary_key=True, auto_created=True, parent_link=True, to='fluent_pages.UrlNode', serialize=False)),
                ('publishing_is_draft', models.BooleanField(db_index=True, default=True, editable=False)),
                ('publishing_modified_at', models.DateTimeField(default=django.utils.timezone.now, editable=False)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('layout', models.ForeignKey(null=True, related_name='icekit_authors_authorlisting_related', blank=True, to='icekit.Layout')),
                ('publishing_linked', models.OneToOneField(null=True, editable=False, related_name='publishing_draft', to='icekit_authors.AuthorListing', on_delete=django.db.models.deletion.SET_NULL)),
            ],
            options={
                'db_table': 'pagetype_icekit_authors_authorlisting',
                'verbose_name': 'Author listing',
            },
            bases=('fluent_pages.htmlpage', models.Model),
        ),
    ]
