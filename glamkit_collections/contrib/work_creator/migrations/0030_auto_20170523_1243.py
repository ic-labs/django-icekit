# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0029_auto_20170523_1149'),
    ]

    operations = [
        migrations.AddField(
            model_name='creatorbase',
            name='brief',
            field=models.TextField(blank=True, help_text=b'A document brief describing the purpose of this content'),
        ),
        migrations.AddField(
            model_name='workbase',
            name='brief',
            field=models.TextField(blank=True, help_text=b'A document brief describing the purpose of this content'),
        ),
        migrations.AlterField(
            model_name='creatorbase',
            name='admin_notes',
            field=models.TextField(blank=True, help_text=b"Administrator's notes about this content"),
        ),
        migrations.AlterField(
            model_name='creatorbase',
            name='birth_date_edtf',
            field=edtf.fields.EDTFField(help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", blank=True, upper_fuzzy_field=b'birth_date_sort_descending', null=True, lower_fuzzy_field=b'birth_date_sort_ascending', upper_strict_field=b'birth_date_latest', verbose_name=b'Date of creation (EDTF)', lower_strict_field=b'birth_date_earliest', natural_text_field=b'birth_date_display'),
        ),
        migrations.AlterField(
            model_name='creatorbase',
            name='death_date_edtf',
            field=edtf.fields.EDTFField(help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", blank=True, upper_fuzzy_field=b'death_date_sort_descending', null=True, lower_fuzzy_field=b'death_date_sort_ascending', upper_strict_field=b'death_date_latest', verbose_name=b'Date of death (EDTF)', lower_strict_field=b'death_date_earliest', natural_text_field=b'death_date_display'),
        ),
        migrations.AlterField(
            model_name='workbase',
            name='admin_notes',
            field=models.TextField(blank=True, help_text=b"Administrator's notes about this content"),
        ),
        migrations.AlterField(
            model_name='workbase',
            name='date_edtf',
            field=edtf.fields.EDTFField(help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", blank=True, upper_fuzzy_field=b'date_sort_descending', null=True, lower_fuzzy_field=b'date_sort_ascending', upper_strict_field=b'date_latest', verbose_name=b'Date of creation (EDTF)', lower_strict_field=b'date_earliest', natural_text_field=b'date_display'),
        ),
    ]
