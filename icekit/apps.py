"""
App configuration for ``icekit`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig, apps
from django.conf import settings
from django.core.management.color import no_style
from django.db import connection
from django.db.models.signals import post_migrate, pre_save
from django.utils.module_loading import autodiscover_modules
from fluent_contents.plugins.oembeditem.models import OEmbedItem


def update_site(sender, **kwargs):
    """
    Update `Site` object matching `SITE_ID` setting with `SITE_DOMAIN` and
    `SITE_PORT` settings.
    """
    Site = apps.get_model('sites', 'Site')
    domain = settings.SITE_DOMAIN
    if settings.SITE_PORT:
        domain += ':%s' % settings.SITE_PORT
    Site.objects.update_or_create(
        pk=settings.SITE_ID,
        defaults=dict(
            domain=domain,
            name=settings.SITE_NAME))

    # We set an explicit pk instead of relying on auto-incrementation,
    # so we need to reset the database sequence.
    sequence_sql = connection.ops.sequence_reset_sql(no_style(), [Site])
    if sequence_sql:
        cursor = connection.cursor()
        for command in sequence_sql:
            cursor.execute(command)


class AppConfig(AppConfig):
    name = 'icekit'

    def ready(self):
        # Monkey-patch `RedirectNodeAdmin` to replace `fieldsets` attribute
        # with `base_fieldsets` to avoid infinitie recursion bug when using
        # django-polymorphic>=0.8, see:
        # https://github.com/django-fluent/django-fluent-pages/issues/110
        from django.conf import settings
        if 'fluent_pages.pagetypes.redirectnode' in settings.INSTALLED_APPS:
            from fluent_pages.pagetypes.redirectnode.admin \
                import RedirectNodeAdmin
            if getattr(RedirectNodeAdmin, 'fieldsets', None):
                RedirectNodeAdmin.base_fieldsets = RedirectNodeAdmin.fieldsets
                RedirectNodeAdmin.fieldsets = None

        # Connect signal handlers.
        post_migrate.connect(update_site, sender=self)

        # Import plugins from installed apps.
        autodiscover_modules('plugins')


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
