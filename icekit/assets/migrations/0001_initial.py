# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.CreateModel(
            name='Asset',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('title', models.CharField(help_text='The title is shown in the "title" attribute', max_length=255, blank=True)),
                ('caption', models.TextField(blank=True)),
                ('admin_notes', models.TextField(help_text='Internal notes for administrators only.', blank=True)),
                ('categories', models.ManyToManyField(related_name='assets_asset_related', to='icekit.MediaCategory', blank=True)),
                ('polymorphic_ctype', models.ForeignKey(related_name='polymorphic_assets.asset_set+', editable=False, to='contenttypes.ContentType', null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]
