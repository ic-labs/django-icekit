# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


def migrate_data(apps, schema_editor):
    MapWithTextItem = apps.get_model('map_with_text.MapWithTextItem')
    for i in MapWithTextItem.objects.all():
        i.share_url_new = i.share_url
        i.save()


def reverse_migrate_data(apps, schema_editor):
    MapWithTextItem = apps.get_model('map_with_text.MapWithTextItem')
    for i in MapWithTextItem.objects.all():
        i.share_url = i.share_url_new
        i.save()


class Migration(migrations.Migration):

    dependencies = [
        ('map_with_text', '0002_auto_20150903_1854'),
    ]

    operations = [
        migrations.RunPython(migrate_data, reverse_migrate_data),
    ]
