# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('ik_links', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='articlelink',
            name='url_override',
            field=icekit.fields.ICEkitURLField(blank=True, max_length=255),
        ),
        migrations.AddField(
            model_name='authorlink',
            name='url_override',
            field=icekit.fields.ICEkitURLField(blank=True, max_length=255),
        ),
        migrations.AddField(
            model_name='pagelink',
            name='url_override',
            field=icekit.fields.ICEkitURLField(blank=True, max_length=255),
        ),
    ]
