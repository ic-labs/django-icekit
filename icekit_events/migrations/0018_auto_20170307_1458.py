# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import colorful.fields


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0017_eventtype_color'),
    ]

    operations = [
        migrations.AlterField(
            model_name='eventtype',
            name='color',
            field=colorful.fields.RGBColorField(default=b'#cccccc', colors=[b'#00BBCC', b'#0055CC', b'#1100CC', b'#7600CC', b'#CC00BB', b'#CC0054', b'#CC1100', b'#CC7700', b'#BBCC00', b'#00CC77', b'#008C99', b'#003F99', b'#0C0099', b'#590099', b'#99008C', b'#99003F', b'#990C00', b'#995900', b'#8C9900', b'#009959']),
        ),
    ]
