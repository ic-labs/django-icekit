# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0020_auto_20170518_2017'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='workbase',
            name='date_edtf_earliest',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='date_edtf_latest',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='date_sort_earliest',
        ),
        migrations.RemoveField(
            model_name='workbase',
            name='date_sort_latest',
        ),
        migrations.AddField(
            model_name='workbase',
            name='date_earliest',
            field=models.DateField(null=True, verbose_name=b'Earliest date', blank=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='date_latest',
            field=models.DateField(null=True, verbose_name=b'Latest date', blank=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='date_sort_ascending',
            field=models.DateField(null=True, verbose_name=b'Ascending sort', blank=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='date_sort_descending',
            field=models.DateField(null=True, verbose_name=b'Descending sort', blank=True),
        ),
        migrations.AlterField(
            model_name='workbase',
            name='date_edtf',
            field=edtf.fields.EDTFField(null=True, help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", verbose_name=b'Date of creation (EDTF)', blank=True),
        ),
    ]
