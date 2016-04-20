from icekit.publishing.models import PublishableFluentContentsPage


class AbstractSearchPage(PublishableFluentContentsPage):
    class Meta:
        abstract = True
        verbose_name = 'Search Page'
