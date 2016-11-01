from . import abstract_models


class OEmbedWithCaptionItem(abstract_models.AbstractOEmbedWithCaptionItem):
    class Meta:
        db_table = "contentitem_oembed_with_caption_item"
