# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('content_browser', '0007_digitalgardenimage_content_type'),
    ]

    operations = [
        migrations.CreateModel(
            name='DigitalGardenImageItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(parent_link=True, auto_created=True, primary_key=True, serialize=False, to='fluent_contents.ContentItem')),
                ('image', models.ForeignKey(help_text='An image from NetX.', to='content_browser.DigitalGardenImage')),
            ],
            options={
                'abstract': False,
                'db_table': 'contentitem_digital_garden_image_digitalgardenimageitem',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
