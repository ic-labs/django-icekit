# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('map_with_text', '0006_auto_20150903_1953'),
    ]

    operations = [
        migrations.RenameField(
            model_name='mapwithtextitem',
            old_name='mapitem_ptr',
            new_name='contentitem_ptr',
        ),
        migrations.RenameField(
            model_name='mapwithtextitem',
            old_name='share_url_new',
            new_name='share_url',
        ),
    ]
