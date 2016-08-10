from fluent_pages.integration.fluent_contents import FluentContentsPage

from icekit.publishing.models import PublishableFluentContentsPage
from icekit.abstract_models import LayoutFieldMixin


class AbstractUnpublishableLayoutPage(FluentContentsPage, LayoutFieldMixin):
    class Meta:
        abstract = True


class AbstractLayoutPage(PublishableFluentContentsPage, LayoutFieldMixin):
    class Meta:
        abstract = True
