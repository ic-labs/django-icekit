# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_person', '0002_remove_personcreator_name_full'),
    ]

    operations = [
        migrations.RenameField(
            model_name='personcreator',
            old_name='life_info_birth_place',
            new_name='birth_place',
        ),
        migrations.RenameField(
            model_name='personcreator',
            old_name='life_info_birth_place_historic',
            new_name='birth_place_historic',
        ),
        migrations.RenameField(
            model_name='personcreator',
            old_name='life_info_death_place',
            new_name='death_place',
        ),
        migrations.RemoveField(
            model_name='personcreator',
            name='life_info_birth_date_display',
        ),
        migrations.RemoveField(
            model_name='personcreator',
            name='life_info_birth_date_edtf',
        ),
        migrations.RemoveField(
            model_name='personcreator',
            name='life_info_death_date_display',
        ),
        migrations.RemoveField(
            model_name='personcreator',
            name='life_info_death_date_edtf',
        ),
    ]
