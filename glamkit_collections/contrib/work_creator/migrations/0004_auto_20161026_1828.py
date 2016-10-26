# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0008_auto_20160920_2114'),
        ('gk_collections_work_creator', '0003_auto_20161026_1606'),
    ]

    operations = [
        migrations.CreateModel(
            name='WorkImage',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True, serialize=False)),
                ('show_title', models.BooleanField(default=False)),
                ('show_caption', models.BooleanField(default=True)),
                ('title_override', models.CharField(blank=True, max_length=512)),
                ('caption_override', models.TextField(blank=True)),
                ('order', models.PositiveIntegerField(default=0, help_text=b'Which order to show this image in the set of images.')),
                ('image', models.ForeignKey(to='icekit_plugins_image.Image', help_text='An image from the image library.')),
            ],
            options={
                'ordering': ('order',),
            },
        ),
        migrations.CreateModel(
            name='WorkImageType',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True, serialize=False)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
            ],
            options={
                'verbose_name': 'Image type',
            },
        ),
        migrations.AlterModelOptions(
            name='workcreator',
            options={'verbose_name': 'Work-Creator relation', 'ordering': ('order', '-is_primary')},
        ),
        migrations.AlterField(
            model_name='workcreator',
            name='is_primary',
            field=models.BooleanField(verbose_name=b'Primary?', default=True),
        ),
        migrations.AlterField(
            model_name='workcreator',
            name='order',
            field=models.PositiveIntegerField(default=0, help_text=b'Which order to show this creator in the list of creators.'),
        ),
        migrations.AddField(
            model_name='workimage',
            name='type',
            field=models.ForeignKey(blank=True, null=True, to='gk_collections_work_creator.WorkImageType'),
        ),
        migrations.AddField(
            model_name='workimage',
            name='work',
            field=models.ForeignKey(to='gk_collections_work_creator.WorkBase'),
        ),
    ]
