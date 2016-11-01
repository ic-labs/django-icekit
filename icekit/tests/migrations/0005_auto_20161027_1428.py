# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.utils.timezone
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('tests', '0004_auto_20160925_0758'),
    ]

    operations = [
        migrations.CreateModel(
            name='PublishingM2MModelA',
            fields=[
                ('id', models.AutoField(primary_key=True, verbose_name='ID', serialize=False, auto_created=True)),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('publishing_linked', models.OneToOneField(on_delete=django.db.models.deletion.SET_NULL, related_name='publishing_draft', to='tests.PublishingM2MModelA', null=True, editable=False)),
            ],
            options={
                'abstract': False,
                'permissions': (('can_publish', 'Can publish'),),
            },
        ),
        migrations.CreateModel(
            name='PublishingM2MModelB',
            fields=[
                ('id', models.AutoField(primary_key=True, verbose_name='ID', serialize=False, auto_created=True)),
                ('publishing_is_draft', models.BooleanField(db_index=True, editable=False, default=True)),
                ('publishing_modified_at', models.DateTimeField(editable=False, default=django.utils.timezone.now)),
                ('publishing_published_at', models.DateTimeField(null=True, editable=False)),
                ('publishing_linked', models.OneToOneField(on_delete=django.db.models.deletion.SET_NULL, related_name='publishing_draft', to='tests.PublishingM2MModelB', null=True, editable=False)),
                ('related_a_models', models.ManyToManyField(to='tests.PublishingM2MModelA', related_name='related_b_models')),
            ],
            options={
                'abstract': False,
                'permissions': (('can_publish', 'Can publish'),),
            },
        ),
        migrations.CreateModel(
            name='PublishingM2MThroughTable',
            fields=[
                ('id', models.AutoField(primary_key=True, verbose_name='ID', serialize=False, auto_created=True)),
                ('a_model', models.ForeignKey(to='tests.PublishingM2MModelA')),
                ('b_model', models.ForeignKey(to='tests.PublishingM2MModelB')),
            ],
        ),
        migrations.AddField(
            model_name='publishingm2mmodelb',
            name='through_related_a_models',
            field=models.ManyToManyField(through='tests.PublishingM2MThroughTable', to='tests.PublishingM2MModelA', related_name='through_related_b_models'),
        ),
    ]
