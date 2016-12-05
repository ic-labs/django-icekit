# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_page_anchor', '0002_auto_20160821_2140'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pageanchoritem',
            name='anchor_name',
            field=models.CharField(help_text=b'ID to use for this section, e.g. `foo`. Link to it with `#foo`.', max_length=60),
        ),
    ]
