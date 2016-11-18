from django.db import models
from icekit.plugins.links.abstract_models import AbstractLinkItem


class WorkLink(AbstractLinkItem):
    item = models.ForeignKey("gk_collections_work_creator.WorkBase")

    class Meta:
        verbose_name = "Work link"


class CreatorLink(AbstractLinkItem):
    item = models.ForeignKey("gk_collections_work_creator.CreatorBase")

    class Meta:
        verbose_name = "Creator link"
