# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('image_gallery', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='imagegalleryshowitem',
            name='slide_show',
            field=models.ForeignKey(help_text='An image gallery.', to='icekit_plugins_slideshow.SlideShow'),
        ),
    ]
