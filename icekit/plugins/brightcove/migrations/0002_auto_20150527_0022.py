# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.db.models.deletion
import django_brightcove.fields


class Migration(migrations.Migration):

    dependencies = [
        ('brightcove', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='brightcoveitem',
            options={'verbose_name': 'Brightcove video', 'verbose_name_plural': 'Brightcove videos'},
        ),
        migrations.AlterField(
            model_name='brightcoveitem',
            name='video',
            field=django_brightcove.fields.BrightcoveField(on_delete=django.db.models.deletion.PROTECT, blank=True, to='django_brightcove.BrightcoveItems', help_text='Provide the video ID from the brightcove video.', null=True, verbose_name='Brightcove'),
            preserve_default=True,
        ),
    ]
