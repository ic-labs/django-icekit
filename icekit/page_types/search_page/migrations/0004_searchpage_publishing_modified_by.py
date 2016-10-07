# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('search_page', '0003_auto_20160810_1856'),
    ]

    operations = [
        migrations.AddField(
            model_name='searchpage',
            name='publishing_modified_by',
            field=models.ForeignKey(blank=True, editable=False, to=settings.AUTH_USER_MODEL, null=True),
        ),
    ]
