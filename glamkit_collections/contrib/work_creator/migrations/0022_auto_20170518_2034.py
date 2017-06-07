# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0021_auto_20170518_2023'),
    ]

    operations = [
        migrations.AddField(
            model_name='creatorbase',
            name='birth_date_display',
            field=models.CharField(blank=True, verbose_name=b'Date of birth (display)', max_length=255, help_text=b'Displays date as formatted for display, rather than sorting.'),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='birth_date_earliest',
            field=models.DateField(blank=True, verbose_name=b'Earliest birth date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='birth_date_edtf',
            field=edtf.fields.EDTFField(verbose_name=b'Date of creation (EDTF)', null=True, help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", blank=True,),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='birth_date_latest',
            field=models.DateField(blank=True, verbose_name=b'Latest birth date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='birth_date_sort_ascending',
            field=models.DateField(blank=True, verbose_name=b'Ascending sort by birth', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='birth_date_sort_descending',
            field=models.DateField(blank=True, verbose_name=b'Descending sort by birth', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='death_date_display',
            field=models.CharField(blank=True, verbose_name=b'Date of death (display)', max_length=255, help_text=b'Displays date as formatted for display, rather than sorting.'),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='death_date_earliest',
            field=models.DateField(blank=True, verbose_name=b'Earliest death date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='death_date_edtf',
            field=edtf.fields.EDTFField(verbose_name=b'Date of death (EDTF)', null=True, help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", blank=True,),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='death_date_latest',
            field=models.DateField(blank=True, verbose_name=b'Latest death date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='death_date_sort_ascending',
            field=models.DateField(blank=True, verbose_name=b'Ascending sort by death', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='death_date_sort_descending',
            field=models.DateField(blank=True, verbose_name=b'Descending sort by death', null=True),
        ),
    ]
