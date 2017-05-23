# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django_countries.fields


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Country',
            fields=[
                ('id', models.AutoField(serialize=False, verbose_name='ID', primary_key=True, auto_created=True)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('iso_country', django_countries.fields.CountryField(max_length=2, blank=True)),
                ('continent', models.CharField(choices=[((b'AS', b'Asia'), (b'AS', b'Asia')), ((b'AF', b'Africa'), (b'AF', b'Africa')), ((b'NA', b'North America'), (b'NA', b'North America')), ((b'SA', b'South America'), (b'SA', b'South America')), ((b'EU', b'Europe'), (b'EU', b'Europe')), ((b'AN', b'Antarctica'), (b'AN', b'Antarctica')), ((b'OC', b'Oceania'), (b'OC', b'Oceania'))], null=True, blank=True, max_length=31)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='GeographicLocation',
            fields=[
                ('id', models.AutoField(serialize=False, verbose_name='ID', primary_key=True, auto_created=True)),
                ('state_province', models.CharField(verbose_name=b'State or province', max_length=255, blank=True)),
                ('city', models.CharField(max_length=255, blank=True)),
                ('neighborhood', models.CharField(max_length=255, blank=True)),
                ('colloquial_historical', models.CharField(max_length=255, help_text=b'The colloquial or historical name of the place, e.g., "East Bay"', blank=True)),
                ('country', models.ForeignKey(null=True, to='glamkit_collections.Country', blank=True)),
            ],
            options={
                'ordering': ('colloquial_historical', 'country', 'state_province', 'city', 'neighborhood'),
            },
        ),
    ]
