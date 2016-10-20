# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


def create_assets(apps, schema_editor):
    # We need to create a new asset for each image
    Image = apps.get_model('icekit_plugins_image', 'Image')
    Asset = apps.get_model('icekit', 'Asset')
    for image in Image.objects.all():
        # Create a new asset
        asset = Asset()
        asset.admin_notes = image.admin_notes
        asset.caption = image.caption
        asset.title = image.title
        asset.save()
        asset.categories.add(*image.categories.all())

        # Set the asset_ptr on the image
        image.asset_ptr = asset
        image.save()


class Migration(migrations.Migration):

    dependencies = [
        ('icekit', '0007_asset'),
        ('icekit_plugins_image', '0008_auto_20160920_2114'),
        ('icekit', '0006_auto_20150911_0744'),
    ]

    operations = [
        # Add the ForeignKey first as not the primary key so we can fake it
        migrations.AddField(
            model_name='image',
            name='asset_ptr',
            field=models.OneToOneField(parent_link=True, auto_created=True, default=1, serialize=False, to='icekit.Asset'),
            preserve_default=False,
        ),
        # Create asset links for existing images
        migrations.RunPython(
            create_assets
        ),
        migrations.RemoveField(
            model_name='image',
            name='admin_notes',
        ),
        migrations.RemoveField(
            model_name='image',
            name='caption',
        ),
        migrations.RemoveField(
            model_name='image',
            name='categories',
        ),
        migrations.RemoveField(
            model_name='image',
            name='id',
        ),
        migrations.RemoveField(
            model_name='image',
            name='title',
        ),
        # Make asset_ptr the primary key
        migrations.AlterField(
            model_name='image',
            name='asset_ptr',
            field=models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='icekit.Asset'),
            preserve_default=False,
        ),
    ]
