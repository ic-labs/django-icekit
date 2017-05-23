# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_pages', '0001_initial'),
        ('tests', '0009_auto_20170519_1232'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='unpublishablelayoutpage',
            name='layout',
        ),
        migrations.RemoveField(
            model_name='unpublishablelayoutpage',
            name='urlnode_ptr',
        ),
        migrations.AlterModelOptions(
            name='publishingm2mmodela',
            options={'permissions': (('can_publish', 'Can publish'), ('can_republish', 'Can republish'))},
        ),
        migrations.AlterModelOptions(
            name='publishingm2mmodelb',
            options={'permissions': (('can_publish', 'Can publish'), ('can_republish', 'Can republish'))},
        ),
        migrations.DeleteModel(
            name='UnpublishableLayoutPage',
        ),
    ]
