# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_collections', '0002_auto_20170412_1520'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='country',
            options={'verbose_name_plural': 'Countries', 'ordering': ('slug',)},
        ),
        migrations.AlterField(
            model_name='country',
            name='continent',
            field=models.CharField(choices=[(b'AS', b'Asia'), (b'AF', b'Africa'), (b'NA', b'North America'), (b'SA', b'South America'), (b'EU', b'Europe'), (b'AN', b'Antarctica'), (b'OC', b'Oceania')], null=True, max_length=31, blank=True),
        ),
        migrations.AlterField(
            model_name='geographiclocation',
            name='colloquial_historical',
            field=models.CharField(verbose_name=b'Colloquial or historical name', help_text=b'The colloquial or historical name of the place, e.g., "East Bay"', max_length=255, blank=True),
        ),
    ]
