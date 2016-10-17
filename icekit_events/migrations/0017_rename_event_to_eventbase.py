# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


def NO_OP(apps, schema_editor):
    pass


def _beat_django_content_types_into_submission(apps, schema_editor, fromname):
    """
    This is a work-around for a bug in Django where renaming a model does not
    also rename the corresponding content types, leading to spurious and
    potentially damaging prompts to delete the old content types pointing
    at 'Event', see https://github.com/django/django/pull/6612
    """
    content_types = apps.get_model('contenttypes.ContentType').objects
    content_types \
        .filter(app_label='icekit_events', model=fromname).delete()


def purge_django_content_type_forward(apps, schema_editor):
    _beat_django_content_types_into_submission(apps, schema_editor, 'event')


def purge_django_content_type_backward(apps, schema_editor):
    _beat_django_content_types_into_submission(apps, schema_editor, 'eventbase')


class Migration(migrations.Migration):

    dependencies = [
        ('icekit_events', '0016_auto_20160929_1504'),
    ]

    operations = [
        migrations.RunPython(
            NO_OP,
            purge_django_content_type_backward),

        migrations.RenameModel(
            'event',
            'eventbase'),
        migrations.AlterField(
            model_name='eventbase',
            name='derived_from',
            field=models.ForeignKey(related_name='derivitives', blank=True, editable=False, to='icekit_events.EventBase', null=True),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='polymorphic_ctype',
            field=models.ForeignKey(related_name='polymorphic_icekit_events.eventbase_set+', editable=False, to='contenttypes.ContentType', null=True),
        ),
        migrations.AlterField(
            model_name='eventbase',
            name='publishing_linked',
            field=models.OneToOneField(related_name='publishing_draft', null=True, on_delete=django.db.models.deletion.SET_NULL, editable=False, to='icekit_events.EventBase'),
        ),
        migrations.AlterField(
            model_name='eventrepeatsgenerator',
            name='event',
            field=models.ForeignKey(related_name='repeat_generators', editable=False, to='icekit_events.EventBase'),
        ),
        migrations.AlterField(
            model_name='occurrence',
            name='event',
            field=models.ForeignKey(related_name='occurrences', editable=False, to='icekit_events.EventBase'),
        ),

        migrations.RunPython(
            purge_django_content_type_forward,
            NO_OP),
    ]
