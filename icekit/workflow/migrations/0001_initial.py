# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='WorkflowStep',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('object_id', models.PositiveIntegerField()),
                ('status', models.CharField(choices=[(b'', b''), (b'pending_review', b'Pending Review'), (b'approved', b'Approved')], max_length=254, default=b'')),
                ('assigned_to', models.ForeignKey(blank=True, to=settings.AUTH_USER_MODEL, null=True, help_text=b'User responsible for item at this stage in the workflow')),
                ('content_type', models.ForeignKey(to='contenttypes.ContentType')),
            ],
        ),
    ]
