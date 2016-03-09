# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0001_initial'),
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Image',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('image', models.ImageField(upload_to=b'uploads/images/', verbose_name='Image field')),
                ('alt_text', models.CharField(help_text="A description of the image for users who don't see images.", max_length=255)),
                ('title', models.CharField(help_text='The title is shown in the caption.', max_length=255, blank=True)),
                ('caption', models.TextField(blank=True)),
                ('is_active', models.BooleanField(default=True)),
                ('admin_notes', models.TextField(help_text='Internal notes for administrators only.', blank=True)),
                ('categories', models.ManyToManyField(related_name='image_image_related', to='icekit.MediaCategory', blank=True)),
            ],
            options={
                'db_table': 'image_image',
            },
        ),
        migrations.CreateModel(
            name='ImageItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('image', models.ForeignKey(help_text='An image from the image library.', to='icekit_plugins_image.Image')),
            ],
            options={
                'db_table': 'contentitem_image_imageitem',
                'verbose_name': 'Reusable Image',
                'verbose_name_plural': 'Reusable Images',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
