# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('icekit_plugins_location', '0002_auto_20170724_1019'),
    ]

    operations = [
        migrations.CreateModel(
            name='LocationItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(primary_key=True, to='fluent_contents.ContentItem', serialize=False, parent_link=True, auto_created=True)),
                ('location', models.ForeignKey(to='icekit_plugins_location.Location')),
            ],
            options={
                'verbose_name_plural': 'Locations',
                'verbose_name': 'Location',
                'db_table': 'contentitem_icekit_plugins_location_locationitem',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
