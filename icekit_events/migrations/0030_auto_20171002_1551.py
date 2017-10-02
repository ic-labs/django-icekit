# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0029_fix_malformed_rrules_20170830_1101'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='cta_text',
            field=models.CharField(default='Book now', blank=True, verbose_name='Call to action', max_length=255, help_text='The label to use for the call to action (CTA) URL for arranging to attend an event. This is only shown if a CTA URL is also provided'),
        ),
    ]
