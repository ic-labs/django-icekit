from icekit.page_types.layout_page.abstract_models import AbstractLayoutPage


class AuthorsPage(AbstractLayoutPage):
    """
    Author listing page to be mounted in fluent pages page tree.
    """
    class Meta:
        verbose_name = 'Authors page'
