from . import abstract_models


class ArticlePage(abstract_models.AbstractArticlePage):
    """
    An Article Page implementation similar to ``FluentPage``.

    ``FluentPage`` was not abstracted from as the layout options were
    wanted to be separated.

    It is also anticipated that this class will be extended
    significantly in the future.
    """
    pass
