from django.apps import AppConfig
from django.db.models.signals import pre_save


def handle_soundcloud_malformed_widths_for_oembeds(sender, instance, **kwargs):
    """
    A signal receiver that prevents soundcloud from triggering ValueErrors
    when we save an OEmbedItem.
    Soundcloud returns "100%", instead of an integer for an OEmbed's width property.
    This is against the OEmbed spec, but actually makes sense in the context of
    responsive design. Unfortunately, the OEmbedItems can only store integers in
    the `width` field, so this becomes a 500 throwing issue.
    The issue is tracked https://github.com/edoburu/django-fluent-contents/issues/65
    """
    if instance.width == '100%':
        instance.width = -100


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = "icekit_plugins_oembed_with_caption"
    verbose_name = "Media embed with caption"

    def ready(self):
        from icekit.plugins.oembed_with_caption.models import OEmbedWithCaptionItem
        pre_save.connect(handle_soundcloud_malformed_widths_for_oembeds,
                         sender=OEmbedWithCaptionItem)
