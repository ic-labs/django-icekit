from django.dispatch import Signal


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
