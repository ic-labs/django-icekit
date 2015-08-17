from fluent_pages.integration.fluent_contents import FluentContentsPage


class AbstractSearchPage(FluentContentsPage):
    class Meta:
        abstract = True
        verbose_name = 'Search Page'
