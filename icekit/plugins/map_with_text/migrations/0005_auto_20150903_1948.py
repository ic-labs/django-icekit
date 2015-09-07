# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


def delete_maps(apps, schema_editor):
    ContentItem = apps.get_model('fluent_contents.ContentItem')
    MapItem = apps.get_model('map.MapItem')

    ci = ContentItem()

    for i in MapItem.objects.all():
        i.contentitem_ptr = ci
        i.save()
        i.delete()


def restore_maps(apps, schema_editor):
    MapItem = apps.get_model('map.MapItem')
    MapWithTextItem = apps.get_model('map_with_text.MapWithTextItem')

    for i in MapWithTextItem.objects.all():
        mi = MapItem(contentitem_ptr=i.contentitem_ptr, share_url=i.share_url)
        mi.save()


class Migration(migrations.Migration):

    dependencies = [
        ('map_with_text', '0004_auto_20150903_1948'),
    ]

    operations = [
        migrations.RunPython(delete_maps, restore_maps),
    ]
