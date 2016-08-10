# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_page_types_article', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='articlepage',
            name='layout',
            field=models.ForeignKey(related_name='icekit_page_types_article_articlepage_related', blank=True, to='icekit.Layout', null=True),
            preserve_default=True,
        ),
        migrations.AlterModelTable(
            name='articlepage',
            table='pagetype_icekit_article_articlepage',
        ),
    ]
