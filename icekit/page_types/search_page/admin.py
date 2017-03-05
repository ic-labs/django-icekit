from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin

from icekit.admin import ICEkitContentsAdmin


class UnpublishableSearchPageAdmin(FluentContentsPageAdmin):
    placeholder_layout_template = 'icekit/page_types/search_page/default.html'


class SearchPageAdmin(FluentContentsPageAdmin, ICEkitContentsAdmin):
    placeholder_layout_template = 'icekit/page_types/search_page/default.html'
