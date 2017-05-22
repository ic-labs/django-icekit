# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import edtf.fields


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0018_workbase_external_ref'),
    ]

    operations = [
        migrations.AlterField(
            model_name='workbase',
            name='date_edtf',
            field=edtf.fields.EDTFField(blank=True, help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, as best as we could parse from the display date, e.g. '1855/1860-06-04'", verbose_name=b'Date of creation (EDTF)', null=True),
        ),
    ]
