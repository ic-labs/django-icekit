from icekit.admin import FluentLayoutsMixin
from icekit.publishing.admin import PublishingAdmin


class PublishableArticleAdmin(PublishingAdmin, FluentLayoutsMixin):
    """
    Add publishing features for non-Page rich content models
    """
    prepopulated_fields = {"slug": ("title",)}

    class Media:
        css = {
            'all': ('admin/production/redactor_field_styles.css',)
        }

