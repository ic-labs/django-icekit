# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_plugins_image', '0009_auto_20161026_2044'),
    ]

    operations = [
        migrations.RenameField(
            model_name='image',
            old_name='admin_notes',
            new_name='notes',
        ),
        migrations.RenameField(
            model_name='image',
            old_name='is_active',
            new_name='is_ok_for_web',
        ),
        migrations.AddField(
            model_name='image',
            name='credit',
            field=models.CharField(help_text='Who or what to credit whenever the image is used.', max_length=255, blank=True),
        ),
        migrations.AddField(
            model_name='image',
            name='date_created',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='image',
            name='date_modified',
            field=models.DateTimeField(default=datetime.datetime(2017, 3, 7, 3, 58, 3, 483597, tzinfo=utc), auto_now=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='image',
            name='height',
            field=models.PositiveIntegerField(default=0, editable=False),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='image',
            name='license',
            field=models.TextField(verbose_name='License/rights information', blank=True),
        ),
        migrations.AddField(
            model_name='image',
            name='maximum_dimension',
            field=models.PositiveIntegerField(help_text='If the size of this image is to be limited to a particular size for distribution, note it here.', null=True, blank=True),
        ),
        migrations.AddField(
            model_name='image',
            name='source',
            field=models.CharField(help_text='Where this image came from.', max_length=255, blank=True),
        ),
        migrations.AddField(
            model_name='image',
            name='width',
            field=models.PositiveIntegerField(default=0, editable=False),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='image',
            name='image',
            field=models.ImageField(upload_to=b'uploads/images/', width_field=b'width', verbose_name='Image file', height_field=b'height'),
        ),
        migrations.AlterField(
            model_name='image',
            name='title',
            field=models.CharField(help_text='You must specify either title or help text. Title can be included in captions.', max_length=255, blank=True),
        ),
    ]
