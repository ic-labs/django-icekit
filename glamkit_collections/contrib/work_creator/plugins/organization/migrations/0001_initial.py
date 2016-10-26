# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='OrganizationCreator',
            fields=[
                ('creatorbase_ptr', models.OneToOneField(serialize=False, to='gk_collections_work_creator.CreatorBase', auto_created=True, primary_key=True, parent_link=True)),
            ],
            options={
                'verbose_name': 'organization',
            },
            bases=('gk_collections_work_creator.creatorbase',),
        ),
    ]
