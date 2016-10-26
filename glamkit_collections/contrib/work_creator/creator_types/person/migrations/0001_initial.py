# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='PersonCreator',
            fields=[
                ('creatorbase_ptr', models.OneToOneField(serialize=False, to='gk_collections_work_creator.CreatorBase', auto_created=True, primary_key=True, parent_link=True)),
                ('name_full', models.CharField(max_length=255, help_text=b'A public "label" composed of the Prefix, First Names, Last Name Prefix, Last Name, Suffix, and Variant Name fields')),
                ('name_given', models.CharField(max_length=255, blank=True, help_text=b'All the names that precede the last name and last name prefix, e.g., "Jan Davidszoon" (de Heem) or "George Wesley" (Bellows)')),
                ('name_family', models.CharField(max_length=255, blank=True, help_text=b'The name you would look up in a standard reference work, e.g., "Rijn," Rembrandt Harmenszoon van or "Sanzio," Raphael')),
                ('gender', models.CharField(max_length=255, blank=True, help_text=b'This field identifies the gender of the creator for rapid retrieval and categorization, e.g., "male" or "female". Use lowercase.')),
                ('primary_occupation', models.CharField(max_length=255, blank=True)),
                ('life_info_birth_date_display', models.CharField(max_length=255, blank=True, null=True, help_text=b'The display version of the creator\'s birth date, e.g. "circa August 1645"')),
                ('life_info_birth_date_edtf', models.CharField(max_length=63, blank=True, help_text=b'<a href="http://www.loc.gov/standards/datetime/implementations.html">EDTF</a> version of the creator\'s birth date, as best as we could parse from the display date e.g. "1645-08~"')),
                ('life_info_birth_place', models.CharField(max_length=255, blank=True, help_text=b'The location of the creator\'s birth, e.g., "Utrecht"')),
                ('life_info_birth_place_historic', models.CharField(max_length=255, blank=True, help_text=b'The historical name of the place at the time of the creator\'s birth, e.g., "Flanders"')),
                ('life_info_death_date_display', models.CharField(max_length=255, blank=True, null=True, help_text=b'The display version of the creator\'s death date, e.g., "before 1720s"')),
                ('life_info_death_date_edtf', models.CharField(max_length=63, blank=True, help_text=b'<a href="http://www.loc.gov/standards/datetime/implementations.html">EDTF</a> version of the creator\'s death date, e.g. "[..172x]"')),
                ('life_info_death_place', models.CharField(max_length=255, blank=True, help_text=b'The location of the creator\'s death, e.g., "Antwerp."')),
                ('background_ethnicity', models.CharField(max_length=255, blank=True, help_text=b'The affiliation of the creator with a group not based on geopolitical boundaries, a cultural affiliation, e.g., "Inuit" or "Mayan."')),
                ('background_nationality', models.CharField(max_length=255, blank=True, help_text=b'This field contains information about the geopolitical entity that claims the creator, expressed as a nationality, e.g., "French," "American," "Flemish."')),
                ('background_neighborhood', models.CharField(max_length=255, blank=True)),
                ('background_city', models.CharField(max_length=255, blank=True)),
                ('background_state_province', models.CharField(max_length=255, blank=True)),
                ('background_country', models.CharField(max_length=255, blank=True)),
                ('background_continent', models.CharField(max_length=255, blank=True)),
            ],
            options={
                'verbose_name': 'person',
            },
            bases=('gk_collections_work_creator.creatorbase',),
        ),
    ]
