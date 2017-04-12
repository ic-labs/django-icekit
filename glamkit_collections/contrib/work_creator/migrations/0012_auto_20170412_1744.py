# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_collections', '0003_auto_20170412_1742'),
        ('gk_collections_work_creator', '0011_role_title_plural'),
    ]

    operations = [
        migrations.CreateModel(
            name='WorkOrigin',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('sort', models.PositiveIntegerField(default=0)),
                ('geographic_location', models.ForeignKey(to='glamkit_collections.GeographicLocation')),
            ],
        ),
        migrations.AddField(
            model_name='workorigin',
            name='work',
            field=models.ForeignKey(to='gk_collections_work_creator.WorkBase'),
        ),
    ]
