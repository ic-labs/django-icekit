from model_utils.managers import PassThroughManager

from . import abstract_models, managers


class Layout(abstract_models.AbstractLayout):
    """
    An implementation of ``fluent_pages.models.db.PageLayout`` that uses
    plugins to get template name choices instead of scanning a directory given
    in settings.
    """
    objects = PassThroughManager.for_queryset_class(managers.LayoutQuerySet)()


class MediaCategory(abstract_models.AbstractMediaCategory):
    """
    A categorisation model for Media assets.
    """
    pass
