# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0010_auto_20170307_1458'),
    ]

    operations = [
        migrations.CreateModel(
            name='ImageRepurposeConfig',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, serialize=False, primary_key=True)),
                ('title', models.CharField(max_length=255)),
                ('slug', models.SlugField(max_length=255)),
                ('width', models.PositiveIntegerField(blank=True, null=True)),
                ('height', models.PositiveIntegerField(blank=True, null=True)),
                ('format', models.CharField(choices=[(b'jpg', b'jpg'), (b'tif', b'tif'), (b'png', b'png'), (b'gif', b'gif')], default=b'jpg', max_length=4)),
                ('style', models.CharField(choices=[(b'default', b'default'), (b'color', b'color'), (b'gray', b'gray')], default=b'default', max_length=16)),
            ],
            options={
                'verbose_name': 'Image derivative configuration',
            },
        ),
        migrations.AlterField(
            model_name='image',
            name='image',
            field=icekit.fields.QuietImageField(verbose_name='Image file', upload_to=b'uploads/images/', height_field=b'height', width_field=b'width'),
        ),
        migrations.AlterField(
            model_name='image',
            name='is_ok_for_web',
            field=models.BooleanField(verbose_name='OK for web', default=True),
        ),
    ]
