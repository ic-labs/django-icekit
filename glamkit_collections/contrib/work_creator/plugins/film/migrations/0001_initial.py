# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_moving_image', '0002_auto_20161026_1312'),
        ('gk_collections_work_creator', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Film',
            fields=[
                ('workbase_ptr', models.OneToOneField(serialize=False, to='gk_collections_work_creator.WorkBase', auto_created=True, primary_key=True, parent_link=True)),
                ('rating_annotation', models.CharField(max_length=255, blank=True, help_text=b'e.g. Contains flashing lights and quidditch')),
                ('imdb_link', models.URLField(verbose_name=b'IMDB link', blank=True, help_text=b"e.g. 'http://www.imdb.com/title/tt2316801/'")),
            ],
            options={
                'abstract': False,
            },
            bases=('gk_collections_work_creator.workbase', models.Model),
        ),
        migrations.CreateModel(
            name='FilmFormat',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True, auto_created=True, verbose_name='ID')),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.AddField(
            model_name='film',
            name='formats',
            field=models.ManyToManyField(blank=True, to='gk_collections_film.FilmFormat'),
        ),
        migrations.AddField(
            model_name='film',
            name='genre',
            field=models.ForeignKey(to='gk_collections_moving_image.Genre', null=True, blank=True),
        ),
        migrations.AddField(
            model_name='film',
            name='media_type',
            field=models.ForeignKey(to='gk_collections_moving_image.MediaType', null=True, blank=True),
        ),
        migrations.AddField(
            model_name='film',
            name='rating',
            field=models.ForeignKey(to='gk_collections_moving_image.Rating', null=True, blank=True),
        ),
    ]
