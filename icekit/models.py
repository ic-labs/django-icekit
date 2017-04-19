from icekit.publishing.models import PublishingModel, \
    PublishableFluentContents, PublishableFluentContentsPage
from icekit.workflow.models import WorkflowStateMixin

from . import abstract_models, managers


class Layout(abstract_models.AbstractLayout):
    """
    An implementation of ``fluent_pages.models.db.PageLayout`` that uses
    plugins to get template name choices instead of scanning a directory given
    in settings.
    """
    objects = managers.LayoutQuerySet.as_manager()


class MediaCategory(abstract_models.AbstractMediaCategory):
    """
    A categorisation model for Media assets.
    """
    class Meta:
        # Resetting verbose name because model rename migrations are slooooow
        verbose_name = 'Asset category'
        verbose_name_plural = 'Asset categories'



class ICEkitContentsMixin(PublishingModel, WorkflowStateMixin):
    """
    An abstract base for generic models that will include ICEkit features:

     - publishing
     - workflow
    """

    class Meta:
        abstract = True


class ICEkitFluentContentsMixin(PublishableFluentContents, WorkflowStateMixin):
    """
    An abstract base for Fluent Contents models that will include ICEkit
    features:

     - publishing
     - workflow
    """

    class Meta:
        abstract = True


class ICEkitFluentContentsPageMixin(
        PublishableFluentContentsPage, WorkflowStateMixin):
    """
    An abstract base for Fluent Page models that will include ICEkit
    features:

     - publishing
     - workflow
    """

    class Meta:
        abstract = True
