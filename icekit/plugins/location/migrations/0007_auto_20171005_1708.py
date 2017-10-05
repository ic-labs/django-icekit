# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_location', '0006_auto_20171005_1525'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='location',
            name='map_embed_code',
        ),
        migrations.RenameField(
            model_name='location',
            old_name='map_center',
            new_name='map_center_description',
        ),
        migrations.RenameField(
            model_name='location',
            old_name='map_marker',
            new_name='map_marker_description',
        ),
        migrations.AlterField(
            model_name='location',
            name='map_center_description',
            field=models.CharField(max_length=255, help_text=b"\n            Map's description or address.\n            <br />\n            If set you must not set the map center latitude or longitude.\n            <br />\n            Examples:\n            <br><br><em>San Francisco Museum of Modern Art</em>\n            <br><br><em>or</em>\n            <br><br><em>151 3rd St, San Francisco, CA 94103</em>\n        ", blank=True),
        ),
        migrations.AddField(
            model_name='location',
            name='map_center_lat',
            field=models.DecimalField(max_digits=9, decimal_places=6, blank=True, null=True, help_text=b"\n            Latitude of map's center point.\n            <br/>\n            If set you must also set the map center longitude, and must not set\n            the map center description\n        "),
        ),
        migrations.AddField(
            model_name='location',
            name='map_center_long',
            field=models.DecimalField(max_digits=9, decimal_places=6, blank=True, null=True, help_text=b"\n            Longitude of map's center point.\n            <br/>\n            If set you must also set the map center latitude, and must not set\n            the map center description\n        "),
        ),
        migrations.AlterField(
            model_name='location',
            name='map_marker_description',
            field=models.CharField(max_length=255, help_text=b"\n            An override for the map's marker, which defaults to the center of\n            the map.\n            <br>\n            The value should take a description or address.\n        ", blank=True),
        ),
        migrations.AddField(
            model_name='location',
            name='map_marker_lat',
            field=models.DecimalField(max_digits=9, decimal_places=6, blank=True, null=True, help_text=b"\n            Latitude of map's marker point.\n            <br/>\n            If set you must also set the map marker longitude, and must not set\n            the map marker description\n        "),
        ),
        migrations.AddField(
            model_name='location',
            name='map_marker_long',
            field=models.DecimalField(max_digits=9, decimal_places=6, blank=True, null=True, help_text=b"\n            Longitude of map's marker point.\n            <br/>\n            If set you must also set the map marker latitude, and must not set\n            the map marker description\n        "),
        ),
        migrations.AlterField(
            model_name='location',
            name='address',
            field=models.TextField(help_text=b"\n            Location's address to show to the public\n        ", blank=True),
        ),
        migrations.AlterField(
            model_name='location',
            name='map_description',
            field=models.TextField(help_text='A textual description of the map.'),
        ),
    ]
