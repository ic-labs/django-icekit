from icekit.publishing.models import PublishableFluentContentsPage

from icekit.abstract_models import LayoutFieldMixin


class AbstractLayoutPage(PublishableFluentContentsPage, LayoutFieldMixin):
    class Meta:
        abstract = True
        verbose_name = 'Layout Page'
