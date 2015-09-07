# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('map_with_text', '0003_auto_20150903_1948'),
    ]

    operations = [
        migrations.AlterField(
            model_name='mapwithtextitem',
            name='mapitem_ptr',
            field=models.OneToOneField(parent_link=True, auto_created=True, primary_key=True,
                                       serialize=False, to='fluent_contents.ContentItem'),
        ),
    ]
