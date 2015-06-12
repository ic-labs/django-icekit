# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0004_auto_20150611_2044'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='layout',
            name='key',
        ),
    ]
