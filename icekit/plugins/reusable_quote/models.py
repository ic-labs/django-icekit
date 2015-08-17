from . import abstract_models


class Quote(abstract_models.AbstractQuote):
    """
    A reusable quote.
    """
    pass


class ReusableQuoteItem(abstract_models.AbstractReusableQuoteItem):
    """
    A quote from the Quote model.
    """
    pass
