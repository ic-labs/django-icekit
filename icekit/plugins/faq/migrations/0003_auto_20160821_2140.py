# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_faq', '0002_auto_20151013_1330'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='faqitem',
            table='contentitem_icekit_plugins_faq_faqitem',
        ),
        migrations.RunSQL(
            "UPDATE django_content_type SET app_label='icekit_plugins_faq' WHERE app_label='faq';"
        ),
    ]
