from django.db import models

class LinkManager(models.Manager):
    def get_queryset(self):
        return super(LinkManager, self).get_queryset().select_related('item')
LinkManager.use_for_related_fields = True
