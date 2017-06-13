# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ik_links', '0006_authorlink_exclude_from_contributions'),
    ]

    operations = [
        migrations.AddField(
            model_name='authorlink',
            name='exclude_from_authorship',
            field=models.BooleanField(default=False, help_text=b'Exclude this author from the list of authors on the page.'),
        ),
    ]
