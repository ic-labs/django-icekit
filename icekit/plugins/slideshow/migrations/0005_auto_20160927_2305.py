# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_slideshow', '0004_auto_20160821_2140'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='slideshow',
            options={'verbose_name': 'Image gallery', 'verbose_name_plural': 'Image galleries'},
        ),
        migrations.AlterField(
            model_name='slideshowitem',
            name='slide_show',
            field=models.ForeignKey(help_text='An image gallery.', to='icekit_plugins_slideshow.SlideShow'),
        ),
    ]
