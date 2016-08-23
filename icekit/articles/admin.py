from icekit.admin import FluentLayoutsMixin
from icekit.publishing.admin import PublishingAdmin

class PublishableFluentModelAdmin(PublishingAdmin, FluentLayoutsMixin):
    """
    Add publishing features for non-Page rich content models
    """
    pass


class PublishableArticleAdmin(PublishableFluentModelAdmin):
    prepopulated_fields = {"slug": ("title",)}
