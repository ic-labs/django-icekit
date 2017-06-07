# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.validators


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0006_auto_20160309_0453'),
    ]

    operations = [
        migrations.CreateModel(
            name='Sponsor',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('url', models.CharField(help_text='It must start with `http://`, `https://` or be a relative URL starting with `/`', max_length=255, validators=[icekit.validators.RelativeURLValidator()], blank=True, verbose_name=b'URL')),
                ('logo', models.ForeignKey(to='icekit_plugins_image.Image')),
            ],
        ),
    ]
