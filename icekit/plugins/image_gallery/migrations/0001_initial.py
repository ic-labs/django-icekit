# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('icekit_plugins_slideshow', '0004_auto_20160821_2140'),
    ]

    operations = [
        migrations.CreateModel(
            name='ImageGalleryShowItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('slide_show', models.ForeignKey(help_text='A slide show from the slide show library.', to='icekit_plugins_slideshow.SlideShow')),
            ],
            options={
                'db_table': 'contentitem_image_gallery_imagegalleryshowitem',
                'verbose_name': 'Image Gallery',
                'verbose_name_plural': 'Image Galleries',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
