# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0005_remove_layout_key'),
    ]

    operations = [
        migrations.AlterField(
            model_name='layout',
            name='template_name',
            field=icekit.fields.TemplateNameField(unique=True, max_length=255, verbose_name='template', choices=[(b'', b'')]),
            preserve_default=True,
        ),
    ]
