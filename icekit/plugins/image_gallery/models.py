from django.utils.translation import ugettext_lazy as _
from ..slideshow import abstract_models


class ImageGalleryShowItem(abstract_models.AbstractSlideShowItem):
    """
    An image gallery from the SlideShow model.
    """
    class Meta:
        verbose_name = _('Image Gallery')
        verbose_name_plural = _('Image Galleries')
