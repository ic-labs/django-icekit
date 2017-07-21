# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0007_auto_20170310_1220'),
    ]

    operations = [
        migrations.CreateModel(
            name='Location',
            fields=[
                ('id', models.AutoField(auto_created=True, serialize=False, verbose_name='ID', primary_key=True)),
                ('brief', models.TextField(blank=True, help_text=b'A document brief describing the purpose of this content')),
                ('admin_notes', models.TextField(blank=True, help_text=b"Administrator's notes about this content")),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('map_description', models.TextField(help_text='A textual description of the location.')),
                ('map_center', models.CharField(blank=True, help_text=b"\n            Location's description, address or latitude/longitude combination.\n            <br />\n            <br />\n            Examples:\n            <br><br><em>San Francisco Museum of Modern Art</em>\n            <br><br><em>or</em>\n            <br><br><em>151 3rd St, San Francisco, CA 94103</em>\n            <br><br><em>or</em>\n            <br><br><em>37.785710, -122.401045</em>\n        ", max_length=255)),
                ('map_zoom', models.PositiveIntegerField(help_text=b"\n            A positive number that indicates the zoom level of the map and\n            defaults to 15.\n            <br>\n            Maps on Google Maps have an integer 'zoom level' which defines the\n            resolution of the current view. Zoom levels between 0 (the lowest\n            zoom level, in which the entire world can be seen on one map) and\n            21+ (down to streets and individual buildings) are possible within\n            the default roadmap view.\n        ", default=15)),
                ('map_marker', models.CharField(blank=True, help_text=b"\n            An override for the map's marker, which defaults to the center of\n            the map.\n            <br>\n            The value should take a similar form to the map center: a\n            description, address, or latitude/longitude combination\n        ", max_length=255)),
                ('map_embed_code', models.TextField(blank=True, help_text=b'\n            The HTML code that embeds a map.\n            <br>\n            This is an optional override for the map automatically generated\n            from the map center, map zoom, and map marker fields\n        ')),
                ('is_home_location', models.BooleanField(help_text=b'\n            Is this location at our institution? If not it is considered to be\n            remote\n        ', default=False)),
                ('address', models.TextField(blank=True, help_text=b"\n            Location's address to show to the public, which may differ from\n            the information used as the map centre.\n        ")),
                ('phone_number', models.CharField(blank=True, help_text=b"\n            Location's contact phone number to show to the public.\n        ", max_length=255)),
                ('url', models.URLField(blank=True, help_text=b"\n            Location's external web site to show to the public.\n        ")),
                ('email', models.EmailField(blank=True, help_text=b"\n            Location's email address to show to the public.\n        ", max_length=254)),
                ('email_call_to_action', models.CharField(help_text=b"\n            Call to action text to show next to the location's email address.\n        ", default=b'Email', max_length=255)),
                ('layout', models.ForeignKey(blank=True, to='icekit.Layout', related_name='icekit_location_location_related', null=True)),
                ('publishing_linked', models.OneToOneField(on_delete=django.db.models.deletion.SET_NULL, null=True, to='icekit_location.Location', related_name='publishing_draft', editable=False)),
            ],
        ),
        migrations.AlterUniqueTogether(
            name='location',
            unique_together=set([('slug', 'publishing_linked')]),
        ),
    ]
