# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ik_links', '0005_auto_20170511_1909'),
    ]

    operations = [
        migrations.AddField(
            model_name='authorlink',
            name='exclude_from_contributions',
            field=models.BooleanField(default=False, help_text=b"Exclude this content from the author's contributions."),
        ),
    ]
