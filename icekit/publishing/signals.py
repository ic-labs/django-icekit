from django.dispatch import Signal


# Sent when a model is about to be published (the draft is sent).
publishing_pre_publish = Signal(providing_args=['instance'])


# Sent when a model is being published, before the draft is saved (the draft is
# sent).
publishing_publish_pre_save_draft = Signal(providing_args=['instance'])


# Sent when a model is published (the draft is sent)
publishing_post_publish = Signal(providing_args=['instance'])


# Sent when a model is about to be unpublished (the draft is sent).
publishing_pre_unpublish = Signal(providing_args=['instance'])


# Sent when a model is unpublished (the draft is sent).
publishing_post_unpublish = Signal(providing_args=['instance'])
