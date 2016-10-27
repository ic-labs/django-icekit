# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_quote', '0003_auto_20160912_2218'),
    ]

    operations = [
        migrations.AddField(
            model_name='quoteitem',
            name='url',
            field=models.URLField(help_text=b'link to the source', blank=True),
        ),
        migrations.AlterField(
            model_name='quoteitem',
            name='organisation',
            field=models.CharField(max_length=255, blank=True),
        ),
    ]
