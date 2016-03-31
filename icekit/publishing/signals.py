from django.dispatch import Signal


def publisher_pre_delete(sender, **kwargs):
    instance = kwargs.get('instance', None)
    if not instance:
        return

    # If the draft record is deleted, the published object should be as well
    if instance.is_draft and instance.publisher_linked:
        instance.unpublish()


# Sent when a model is about to be published (the draft is sent).
publisher_pre_publish = Signal(providing_args=['instance'])


# Sent when a model is being published, before the draft is saved (the draft is
# sent).
publisher_publish_pre_save_draft = Signal(providing_args=['instance'])


# Sent when a model is published (the draft is sent)
publisher_post_publish = Signal(providing_args=['instance'])


# Sent when a model is about to be unpublished (the draft is sent).
publisher_pre_unpublish = Signal(providing_args=['instance'])


# Sent when a model is unpublished (the draft is sent).
publisher_post_unpublish = Signal(providing_args=['instance'])
