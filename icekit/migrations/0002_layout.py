# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone
import icekit.validators


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Layout',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
                ('key', models.SlugField(help_text='A short name to identify the layout programmatically.', verbose_name='key')),
                ('title', models.CharField(max_length=255, verbose_name='title')),
                ('template_name', models.CharField(max_length=255, validators=[icekit.validators.template_name])),
            ],
            options={
                'ordering': ('title',),
            },
            bases=(models.Model,),
        ),
    ]
