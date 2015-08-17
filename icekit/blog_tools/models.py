from model_utils.managers import PassThroughManager

from . import abstract_models, managers


class ContentCategory(abstract_models.AbstractContentCategory):
    """
    Provides a basic Category
    """
    pass


class Location(abstract_models.AbstractLocation):
    """
    Adds a named place relation to a Blog Post.

    e.g. Upcoming at <Museum of Contemporary Art> Oct 2015
    """
    pass


class BlogPost(abstract_models.AbstractBlogPost):
    objects = PassThroughManager.for_queryset_class(managers.PostQuerySet)()


class PostItem(abstract_models.AbstractPostItem):
    """
    A post instance.

    This is a working, out-of-the-box blog item, but you probably want
    to copy this and replace the FK reference in your own site.
    """
    pass
