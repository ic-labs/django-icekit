# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('tests', '0007_auto_20161118_1044'),
    ]

    operations = [
        migrations.AlterField(
            model_name='article',
            name='parent',
            field=models.ForeignKey(to='tests.ArticleListing', on_delete=django.db.models.deletion.PROTECT),
        ),
        migrations.AlterField(
            model_name='articlelisting',
            name='hero_image',
            field=models.ForeignKey(related_name='+', to='icekit_plugins_image.Image', on_delete=django.db.models.deletion.SET_NULL, null=True, blank=True, help_text=b'The hero image for this content.'),
        ),
        migrations.AlterField(
            model_name='layoutpagewithrelatedpages',
            name='hero_image',
            field=models.ForeignKey(related_name='+', to='icekit_plugins_image.Image', on_delete=django.db.models.deletion.SET_NULL, null=True, blank=True, help_text=b'The hero image for this content.'),
        ),
    ]
