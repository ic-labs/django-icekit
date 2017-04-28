# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_contact_person', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='contactpersonitem',
            options={'verbose_name': 'Contact Person'},
        ),
    ]
