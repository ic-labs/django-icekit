# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0032_tidy_names'),
    ]

    operations = [
        migrations.AlterField(
            model_name='creatorbase',
            name='name_display',
            field=models.CharField(verbose_name=b'Display name', max_length=255, help_text=b'The commonly known or generally recognized name of the creator, for display, publication and reproduction purposes, e.g., "Rembrandt" or "Guercino" as opposed to the full name "Rembrandt Harmenszoon Van Rijn" or "Giovanni Francesco Barbieri."', blank=True),
        ),
        migrations.AlterField(
            model_name='creatorbase',
            name='name_full',
            field=models.CharField(verbose_name=b'Full name', max_length=255, help_text=b'A public "label" for the creator, from which all other name values will be derived unless they are also provided. E.g. for Person, composed of the Prefix, First Names, Last Name Prefix, Last Name, Suffix, and Variant Name fields'),
        ),
        migrations.AlterField(
            model_name='creatorbase',
            name='name_sort',
            field=models.CharField(verbose_name=b'Name for sorting', max_length=255, help_text=b'A behind-the-scenes value to use when sorting lists of creators, so that each creator may be found where expected. Generally, use "lastname, firstname", although exceptions may exist, such as "Leonardo da Vinci". Omit words that are to be ignored when sorting, such as "The".'),
        ),
    ]
