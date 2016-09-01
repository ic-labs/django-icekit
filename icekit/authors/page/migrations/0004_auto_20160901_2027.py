# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_authors_page', '0003_auto_20160901_2026'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='authorspage',
            options={'verbose_name': 'Authors page'},
        ),
        migrations.AlterField(
            model_name='authorspage',
            name='layout',
            field=models.ForeignKey(related_name='icekit_authors_page_authorspage_related', to='icekit.Layout', null=True, blank=True),
        ),
        migrations.AlterModelTable(
            name='authorspage',
            table='pagetype_icekit_authors_page_authorspage',
        ),
    ]
