from . import abstract_models


class SearchPage(abstract_models.AbstractSearchPage):
    class Meta:
        db_table = "icekit_searchpage"