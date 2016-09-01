# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors_page', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='authorlisting',
            name='layout',
            field=models.ForeignKey(blank=True, to='icekit.Layout', null=True, related_name='icekit_authors_page_authorlisting_related'),
        ),
        migrations.AlterModelTable(
            name='authorlisting',
            table='pagetype_icekit_authors_page_authorlisting',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_authors_page' WHERE app_label='page';"),
    ]
