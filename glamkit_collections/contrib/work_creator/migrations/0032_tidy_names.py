# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models

def update_work_names(apps, schema_editor):
    CreatorBase = apps.get_model("gk_collections_work_creator", "CreatorBase")

    for c in CreatorBase.objects.all():
        save = False

        # Set name_full on all records
        if not c.name_full:
            c.name_full = c.name_display
            save = True

        # Clear display name if it's the same as full name
        if c.name_display == c.name_full:
            c.name_display = ""
            save = True

        # fix legacy projects where the sort name is the same as the display
        # name. It should normally be lastname, firstname.
        # Ctype 151 is the Organization model for the only project that
        # needs it.
        if c.name_sort == (c.name_display or c.name_full) and \
                c.polymorphic_ctype_id != 151:
            names = (c.name_display or c.name_full).strip().split()
            if len(names) > 1:
                c.name_sort = u"%s, %s" % (names[-1], " ".join(names[:-1]))
            else:
                c.name_sort = (c.name_display or c.name_full).strip()
            save = True

        if save:
            c.save()


def _(apps, schema_editor):
    pass

class Migration(migrations.Migration):

    dependencies = [
        ('gk_collections_work_creator', '0031_auto_20170606_1126'),
    ]

    operations = [
        migrations.RunPython(update_work_names, _)
    ]
