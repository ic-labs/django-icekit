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
    pass
