# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0007_auto_20161028_1904'),
    ]

    operations = [
        migrations.AlterField(
            model_name='workbase',
            name='date_display',
            field=models.CharField(blank=True, verbose_name=b'Date of creation (display)', max_length=255, help_text=b'Displays date as formatted for labels and reports, rather than sorting.'),
        ),
        migrations.AlterField(
            model_name='workbase',
            name='date_edtf',
            field=models.CharField(null=True, blank=True, verbose_name=b'Date of creation (EDTF)', max_length=64, help_text=b"an <a href='http://www.loc.gov/standards/datetime/implementations.html'>EDTF</a>-formatted date, as best as we could parse from the display date, e.g. '1855/1860-06-04'"),
        ),
    ]
