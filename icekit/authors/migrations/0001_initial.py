# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import fluent_contents.extensions
import icekit.validators


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0006_auto_20160309_0453'),
    ]

    operations = [
        migrations.CreateModel(
            name='Author',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='ID', auto_created=True)),
                ('first_name', models.CharField(max_length=255)),
                ('last_name', models.CharField(max_length=255, blank=True)),
                ('slug', models.SlugField(unique=True)),
                ('url', models.CharField(max_length=255, help_text='The URL for the authors website.', validators=[icekit.validators.RelativeURLValidator()], blank=True)),
                ('introduction', fluent_contents.extensions.PluginHtmlField(help_text='An introduction about the author used on list pages.', verbose_name='introduction')),
                ('portrait', models.ForeignKey(null=True, blank=True, to='icekit_plugins_image.Image')),
            ],
        ),
    ]
