# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0012_auto_20170502_2209'),
    ]

    operations = [
        migrations.AddField(
            model_name='creatorbase',
            name='name_full',
            field=models.CharField(max_length=255, help_text=b'A public "label" for the creator, from which all other name values will be derived unless they are also provided. E.g. for Person, composed of the Prefix, First Names, Last Name Prefix, Last Name, Suffix, and Variant Name fields', default=''),
            preserve_default=False,
        ),
    ]
