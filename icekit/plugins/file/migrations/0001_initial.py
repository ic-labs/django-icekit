# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('icekit', '0005_remove_layout_key'),
    ]

    operations = [
        migrations.CreateModel(
            name='File',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('file', models.FileField(upload_to=b'uploads/files/', verbose_name='File field')),
                ('title', models.CharField(max_length=255, blank=True)),
                ('is_active', models.BooleanField(default=True)),
                ('admin_notes', models.TextField(help_text='Internal notes for administrators only.', blank=True)),
                ('categories', models.ManyToManyField(related_name='file_file_related', to='icekit.MediaCategory', blank=True)),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='FileItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('file', models.ForeignKey(help_text='A file from the file library.', to='file.File')),
            ],
            options={
                'abstract': False,
                'db_table': 'contentitem_file_fileitem',
                'verbose_name': 'File',
                'verbose_name_plural': 'Files',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
