from django.apps import AppConfig
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType


class AppConfig(AppConfig):
    name = '.'.join(__name__.split('.')[:-1])
    label = 'icekit_plugins_iiif'
    verbose_name = "IIIF Basics"

    def ready(self):
        # Create custom permission pointing to User, because we have no other
        # model to hang it off for now...
        # TODO This is a hack, find a better way
        User = get_user_model()
        content_type = ContentType.objects.get_for_model(User)
        Permission.objects.get_or_create(
            codename='can_use_iiif_image_api',
            name='Can Use IIIF Image API',
            content_type=content_type,
        )
