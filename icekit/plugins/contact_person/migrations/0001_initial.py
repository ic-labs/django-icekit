# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ContactPerson',
            fields=[
                ('id', models.AutoField(serialize=False, auto_created=True, primary_key=True, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('title', models.CharField(max_length=255, blank=True)),
                ('phone', models.CharField(max_length=255, blank=True)),
                ('email', models.EmailField(max_length=255, blank=True)),
            ],
            options={
                'verbose_name_plural': 'Contact people',
            },
        ),
        migrations.CreateModel(
            name='ContactPersonItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(primary_key=True, serialize=False, auto_created=True, parent_link=True, to='fluent_contents.ContentItem')),
                ('contact', models.ForeignKey(to='icekit_plugins_contact_person.ContactPerson')),
            ],
            options={
                'db_table': 'contentitem_icekit_plugins_contact_person_contactpersonitem',
                'verbose_name': 'Contact Item',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
