# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        migrations.CreateModel(
            name='BarWithLayout',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('layout', models.ForeignKey(related_name='tests_barwithlayout_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='BaseModel',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
                ('modified', models.DateTimeField(default=django.utils.timezone.now, editable=False, db_index=True)),
            ],
            options={
                'ordering': ('-id',),
                'abstract': False,
                'get_latest_by': 'pk',
            },
        ),
        migrations.CreateModel(
            name='BazWithLayout',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('layout', models.ForeignKey(related_name='tests_bazwithlayout_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='FooWithLayout',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('layout', models.ForeignKey(related_name='tests_foowithlayout_related', blank=True, to='icekit.Layout', null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='ImageTest',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('image', models.ImageField(upload_to=b'testing/')),
            ],
        ),
    ]
