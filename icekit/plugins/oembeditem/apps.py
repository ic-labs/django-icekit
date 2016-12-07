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

class OEmbedAppConfig(AppConfig):
    name = 'fluent_contents.plugins.oembeditem'

    def ready(self):
        from fluent_contents.plugins.oembeditem.models import OEmbedItem
        pre_save.connect(handle_soundcloud_malformed_widths_for_oembeds, sender=OEmbedItem)

