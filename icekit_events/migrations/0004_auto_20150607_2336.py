# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0003_auto_20150607_2314'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='event',
            unique_together=set([]),
        ),
    ]
