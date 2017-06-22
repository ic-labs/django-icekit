# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Navigation',
            fields=[
                ('id', models.AutoField(serialize=False, auto_created=True, primary_key=True, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('slug', models.SlugField()),
                ('pre_html', models.TextField(default=b'<nav><ul>', blank=True)),
                ('post_html', models.TextField(default=b'</ul></nav>', blank=True)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]
