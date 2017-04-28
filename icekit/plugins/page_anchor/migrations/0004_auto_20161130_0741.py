# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_page_anchor', '0003_auto_20161125_1538'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pageanchoritem',
            name='anchor_name',
            field=models.CharField(help_text=b'ID to use for this section, e.g. `foo`, without the `#`. Link to it with `#foo`.', max_length=60),
        ),
    ]
