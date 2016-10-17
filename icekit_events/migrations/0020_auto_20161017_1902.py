# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0019_auto_20161017_1901'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventbase',
            name='cta_url',
            field=icekit.fields.ICEkitURLField(help_text='The URL where visitors can arrange to attend an event by purchasing tickets or RSVPing.', max_length=300, verbose_name='CTA URL', null=True, blank=True),
        ),
        migrations.AlterField(
            model_name='eventrepeatsgenerator',
            name='event',
            field=models.ForeignKey(editable=False, to='icekit_events.EventBase', related_name='repeat_generators'),
        ),
    ]
