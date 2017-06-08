# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models

def migrate_origin_locations(apps, _):
    """
    Copy origin_* fields to a new GeographicLocation.
    """

    Country = apps.get_model("glamkit_collections", "Country")
    GeographicLocation = apps.get_model("glamkit_collections", "GeographicLocation")
    WorkOrigin = apps.get_model("gk_collections_work_creator", "WorkOrigin")
    WorkBase = apps.get_model("gk_collections_work_creator", "WorkBase")

    countries = dict(((c.iso_country, c) for c in Country.objects.all()))

    for w in WorkBase.objects.all():
        if w.origin_country or \
            w.origin_state_province or \
            w.origin_city or \
            w.origin_neighborhood or \
            w.origin_colloquial:
            loc, created = GeographicLocation.objects.get_or_create(
                country=countries.get(w.origin_country, None),
                state_province=w.origin_state_province,
                city=w.origin_city,
                neighborhood=w.origin_neighborhood,
                colloquial_historical=w.origin_colloquial
            )
            WorkOrigin.objects.create(work=w, geographic_location=loc)

def rev(_, __):
    pass

class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_collections', '0002_auto_20170412_1520'),
        ('gk_collections_work_creator', '0012_auto_20170412_1744'),
    ]

    operations = [
        migrations.RunPython(migrate_origin_locations, rev)
    ]
