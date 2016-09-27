# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import icekit.fields


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_articles', '0006_auto_20160926_2029'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='layoutarticle',
            options={'verbose_name': 'Article'},
        ),
        migrations.AlterModelOptions(
            name='redirectarticle',
            options={'verbose_name': 'Redirect'},
        ),
        migrations.AddField(
            model_name='redirectarticle',
            name='new_url',
            field=icekit.fields.ICEkitURLField(help_text='The URL to redirect to.', default='http://google.com'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='redirectarticle',
            name='redirect_type',
            field=models.IntegerField(help_text="Use 'normal redirect' unless you want to transfer SEO ranking to the new page.", verbose_name='Redirect type', choices=[(302, 'Normal redirect'), (301, 'Permanent redirect (for SEO ranking)')], default=302),
        ),
    ]
