# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fluent_contents', '0001_initial'),
        ('glamkit_sponsors', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='BeginSponsorBlockItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, to='fluent_contents.ContentItem', auto_created=True, parent_link=True, primary_key=True)),
                ('text', models.TextField(help_text=b'HTML is allowed', blank=True)),
            ],
            options={
                'db_table': 'contentitem_glamkit_sponsors_beginsponsorblockitem',
                'verbose_name': 'Begin Sponsor Block',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='EndSponsorBlockItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, to='fluent_contents.ContentItem', auto_created=True, parent_link=True, primary_key=True)),
                ('text', models.TextField(help_text=b'HTML is allowed', blank=True)),
            ],
            options={
                'db_table': 'contentitem_glamkit_sponsors_endsponsorblockitem',
                'verbose_name': 'End sponsor block',
            },
            bases=('fluent_contents.contentitem',),
        ),
        migrations.CreateModel(
            name='SponsorPromoItem',
            fields=[
                ('contentitem_ptr', models.OneToOneField(serialize=False, to='fluent_contents.ContentItem', auto_created=True, parent_link=True, primary_key=True)),
                ('title', models.CharField(help_text='An optional title that will appear at the top of the sponsor logo e.g. Presenting Sponsor.', max_length=120, blank=True)),
                ('width', models.IntegerField(help_text=b'The width to show the sponsor logo, default 200px', default=200)),
                ('quality', models.IntegerField(help_text=b'The JPEG quality to use for the sponsor logo, default 85%', default=85)),
                ('sponsor', models.ForeignKey(to='glamkit_sponsors.Sponsor')),
            ],
            options={
                'db_table': 'contentitem_glamkit_sponsors_sponsorpromoitem',
                'verbose_name': 'Sponsor promo',
            },
            bases=('fluent_contents.contentitem',),
        ),
    ]
