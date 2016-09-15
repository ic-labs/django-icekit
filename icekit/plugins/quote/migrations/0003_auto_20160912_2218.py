# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_quote', '0002_auto_20160821_2140'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='quoteitem',
            options={'verbose_name': 'Pull quote'},
        ),
        migrations.AddField(
            model_name='quoteitem',
            name='organisation',
            field=models.CharField(help_text=b'only shown if attribution is given', max_length=255, blank=True),
        ),
    ]
