# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


def make_type_fixtures(apps, _):
    EventType = apps.get_model("icekit_events", "EventType")
    EventType.objects.get_or_create(
        slug="education",
        defaults=dict(
            title="Education",
            is_public=False,
        )
    )
    EventType.objects.get_or_create(
        slug="members",
        defaults=dict(
            title="Members",
            is_public=False,
        )
    )

def backwards(apps, _):
    pass

class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0006_auto_20161107_1747'),
    ]

    operations = [
        migrations.RunPython(make_type_fixtures, backwards)
    ]
