# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0030_auto_20170523_1243'),
    ]

    operations = [
        migrations.RenameField(
            model_name='workbase',
            old_name='date_display',
            new_name='creation_date_display',
        ),
        migrations.RenameField(
            model_name='workbase',
            old_name='date_earliest',
            new_name='creation_date_earliest',
        ),
        migrations.RenameField(
            model_name='workbase',
            old_name='date_latest',
            new_name='creation_date_latest',
        ),
        migrations.RenameField(
            model_name='workbase',
            old_name='date_sort_ascending',
            new_name='creation_date_sort_ascending',
        ),
        migrations.RenameField(
            model_name='workbase',
            old_name='date_sort_descending',
            new_name='creation_date_sort_descending',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='birth_date_display',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='birth_date_earliest',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='birth_date_edtf',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='birth_date_latest',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='birth_date_sort_ascending',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='birth_date_sort_descending',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='death_date_display',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='death_date_earliest',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='death_date_edtf',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='death_date_latest',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='death_date_sort_ascending',
        ),
        migrations.RemoveField(
            model_name='creatorbase',
            name='death_date_sort_descending',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='date_edtf',
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='end_date_display',
            field=models.CharField(max_length=255, verbose_name=b'Date of death/closure (display)', blank=True, help_text=b'Displays date as formatted for display, rather than sorting.'),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='end_date_earliest',
            field=models.DateField(blank=True, verbose_name=b'Earliest end date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='end_date_edtf',
            field=edtf.fields.EDTFField(lower_fuzzy_field=b'end_date_sort_ascending', upper_strict_field=b'end_date_latest', null=True, verbose_name=b'Date of death/closure (EDTF)', upper_fuzzy_field=b'end_date_sort_descending', natural_text_field=b'end_date_display', blank=True, lower_strict_field=b'end_date_earliest', help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'"),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='end_date_latest',
            field=models.DateField(blank=True, verbose_name=b'Latest end date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='end_date_sort_ascending',
            field=models.DateField(blank=True, verbose_name=b'Ascending sort by end', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='end_date_sort_descending',
            field=models.DateField(blank=True, verbose_name=b'Descending sort by end', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='start_date_display',
            field=models.CharField(max_length=255, verbose_name=b'Date of birth/creation (display)', blank=True, help_text=b'Displays date as formatted for display, rather than sorting.'),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='start_date_earliest',
            field=models.DateField(blank=True, verbose_name=b'Earliest start date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='start_date_edtf',
            field=edtf.fields.EDTFField(lower_fuzzy_field=b'start_date_sort_ascending', upper_strict_field=b'start_date_latest', null=True, verbose_name=b'Date of birth/creation (EDTF)', upper_fuzzy_field=b'start_date_sort_descending', natural_text_field=b'start_date_display', blank=True, lower_strict_field=b'start_date_earliest', help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'"),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='start_date_latest',
            field=models.DateField(blank=True, verbose_name=b'Latest start date', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='start_date_sort_ascending',
            field=models.DateField(blank=True, verbose_name=b'Ascending sort by start', null=True),
        ),
        migrations.AddField(
            model_name='creatorbase',
            name='start_date_sort_descending',
            field=models.DateField(blank=True, verbose_name=b'Descending sort by start', null=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='creation_date_edtf',
            field=edtf.fields.EDTFField(lower_fuzzy_field=b'creation_date_sort_ascending', upper_strict_field=b'creation_date_latest', null=True, verbose_name=b'Date of creation (EDTF)', upper_fuzzy_field=b'creation_date_sort_descending', natural_text_field=b'creation_date_display', blank=True, lower_strict_field=b'creation_date_earliest', help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'"),
        ),
    ]
