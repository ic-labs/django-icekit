# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0001_initial'),
        ('icekit', '0002_layout'),
    ]

    operations = [
        migrations.AddField(
            model_name='layout',
            name='content_types',
            field=models.ManyToManyField(to='contenttypes.ContentType'),
            preserve_default=True,
        ),
    ]
