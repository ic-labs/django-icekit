from . import abstract_models


class MapItem(abstract_models.AbstractMapItem):
    """
    Embeds a Google Map inside an iframe from the Share URL.

    Rather than store the width/height in the DB, update the template
    used or override with CSS.
    """
    pass
