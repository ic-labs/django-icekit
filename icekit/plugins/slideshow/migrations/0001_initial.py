# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='SlideShow',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('title', models.CharField(max_length=255)),
                ('show_title', models.BooleanField(default=False, help_text='Should the title of the slide show be displayed?')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SlideShowItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('slide_show', models.ForeignKey(help_text='A slide show from the slide show library.', to='slideshow.SlideShow')),
            ],
            options={
                'db_table': 'contentitem_slideshow_slideshowitem',
                'verbose_name': 'Reusable slide show',
                'verbose_name_plural': 'Reusable slide shows',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
