# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0019_auto_20170515_2004'),
    ]

    operations = [
        migrations.AddField(
            model_name='workbase',
            name='date_edtf_earliest',
            field=models.DateField(help_text=b'The earliest date the EDTF range might reasonably cover.', blank=True, null=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='date_edtf_latest',
            field=models.DateField(help_text=b'The latest date the EDTF range might reasonably cover.', blank=True, null=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='date_sort_earliest',
            field=models.DateField(help_text=b'The earliest obvious date represented by the EDTF.', blank=True, null=True),
        ),
        migrations.AddField(
            model_name='workbase',
            name='date_sort_latest',
            field=models.DateField(help_text=b'The latest obvious date represented by the EDTF.', blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='workbase',
            name='date_display',
            field=models.CharField(help_text=b'Displays date as formatted for display, rather than sorting.', max_length=255, verbose_name=b'Date of creation (display)', blank=True),
        ),
        migrations.AlterField(
            model_name='workbase',
            name='date_edtf',
            field=edtf.fields.EDTFField(help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", verbose_name=b'Date of creation (EDTF)', null=True),
        ),
    ]
