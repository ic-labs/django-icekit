from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin

from icekit.publishing.admin import PublishingAdmin


class UnpublishableSearchPageAdmin(FluentContentsPageAdmin):
    placeholder_layout_template = 'icekit/page_types/search_page/default.html'


class SearchPageAdmin(FluentContentsPageAdmin, PublishingAdmin):
    placeholder_layout_template = 'icekit/page_types/search_page/default.html'
