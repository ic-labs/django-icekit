from plugins.models import AbstractACMILinkItem
from . import abstract_models
from django.db import models

class LayoutPage(abstract_models.AbstractLayoutPage):

    class Meta:
        verbose_name = "Layout page"


class PageLink(AbstractACMILinkItem):
    item = models.ForeignKey("fluent_pages.Page")

    class Meta:
        verbose_name = "Page link"
