# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from django.template.defaultfilters import slugify
from forms_builder.forms.utils import unique_slug


def create_slugs(apps, _):
    GL = apps.get_model('glamkit_collections', 'GeographicLocation')

    for self in GL.objects.all():

        if not self.slug:

            levels = [x for x in (
            self.neighborhood, self.city, self.state_province) if
                      x]
            if self.country:
                levels.append(self.country.title)

            r = ", ".join(levels)
            if self.colloquial_historical:
                if r:
                    r ="{0} ({1})".format(self.colloquial_historical, r)
                else:
                    r = self.colloquial_historical

            self.slug = unique_slug(type(self).objects, 'slug', slugify(unicode(r)))
            self.save()


class Migration(migrations.Migration):

    dependencies = [
        ('glamkit_collections', '0003_auto_20170412_1742'),
    ]

    operations = [
        migrations.AddField(
            model_name='geographiclocation',
            name='slug',
            field=models.SlugField(blank=True),
        ),
        migrations.RunPython(create_slugs, lambda x, y: None)
    ]
