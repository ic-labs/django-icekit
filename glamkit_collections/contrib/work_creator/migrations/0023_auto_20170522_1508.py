# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0022_auto_20170518_2034'),
    ]

    operations = [
        migrations.AlterField(
            model_name='creatorbase',
            name='birth_date_edtf',
            field=edtf.fields.EDTFField(help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", verbose_name=b'Date of creation (EDTF)', blank=True, null=True, natural_text_field=b'birth_date_display'),
        ),
        migrations.AlterField(
            model_name='creatorbase',
            name='death_date_edtf',
            field=edtf.fields.EDTFField(help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", verbose_name=b'Date of death (EDTF)', blank=True, null=True, natural_text_field=b'death_date_display'),
        ),
        migrations.AlterField(
            model_name='workbase',
            name='date_edtf',
            field=edtf.fields.EDTFField(help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, parsed from the display date, e.g. '1855/1860-06-04'", verbose_name=b'Date of creation (EDTF)', blank=True, null=True, natural_text_field=b'date_display'),
        ),
    ]
