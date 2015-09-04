# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0003_layout_content_types'),
    ]

    operations = [
        migrations.AlterField(
            model_name='layout',
            name='content_types',
            field=models.ManyToManyField(help_text=b'Types of content for which this layout will be allowed.', to='contenttypes.ContentType'),
            preserve_default=True,
        ),
    ]
