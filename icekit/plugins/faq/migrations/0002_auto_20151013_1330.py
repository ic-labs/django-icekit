# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import fluent_contents.extensions


class Migration(migrations.Migration):

    dependencies = [
        ('faq', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='faqitem',
            name='answer',
            field=fluent_contents.extensions.PluginHtmlField(),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='faqitem',
            name='question',
            field=fluent_contents.extensions.PluginHtmlField(),
            preserve_default=True,
        ),
    ]
