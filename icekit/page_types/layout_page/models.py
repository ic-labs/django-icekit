from icekit.mixins import HeroMixin, ListableMixin
from . import abstract_models


class LayoutPage(abstract_models.AbstractLayoutPage, HeroMixin, ListableMixin):

    class Meta:
        verbose_name = "Layout page"
