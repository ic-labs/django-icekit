# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import eventkit.models


class Migration(migrations.Migration):

    dependencies = [
        ('eventkit', '0006_auto_20150529_1832'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='recurrence_rule',
            field=eventkit.models.RecurrenceRuleField(help_text='An iCalendar (RFC2445) recurrence rule that defines when this event repeats.', null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='recurrencerule',
            name='recurrence_rule',
            field=eventkit.models.RecurrenceRuleField(help_text='An iCalendar (RFC2445) recurrence rule that defines when an event repeats. Unique.', unique=True),
            preserve_default=True,
        ),
    ]
