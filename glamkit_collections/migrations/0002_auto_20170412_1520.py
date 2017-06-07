# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from django.template.defaultfilters import slugify

from django_countries import countries

from glamkit_collections.utils.countries import \
    ISO_COUNTRIES_CONTINENTS


def create_countries(apps, _):
    continents = dict(ISO_COUNTRIES_CONTINENTS)
    Country = apps.get_model("glamkit_collections", "Country")

    # create a Country object for every country in django-countries, looking
    # up the continent first.
    for code, country in countries:
        continent = continents.get(code, None)
        Country.objects.get_or_create(iso_country=code, defaults={'continent': continent, 'title': country, 'slug': slugify(country) })


def rev(_, __):
    pass

class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_collections', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(create_countries, rev)
    ]
