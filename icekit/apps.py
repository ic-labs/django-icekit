"""
App configuration for ``icekit`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig, apps
from django.conf import settings
from django.core.management.color import no_style
from django.db import connection
from django.db.models.signals import post_migrate
from django.utils.module_loading import autodiscover_modules


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
        # django-polymorphic versions >= 0.8 and < 1.1, see:
        # https://github.com/django-fluent/django-fluent-pages/issues/110
        from distutils.version import StrictVersion as SV
        from django.conf import settings
        import polymorphic
        import fluent_pages
        if (
            (SV('0.8') <= SV(polymorphic.__version__) < SV('1.1')) and
            # Don't apply for Fluent Pages versions >= 1.1 to avoid problems
            # with re-registering `RedirectNodeAdmin` in 1.1.3 and because it
            # isn't necessary anyway since 1.1, per
            # github.com/django-fluent/django-fluent-pages/pull/123
            (SV(fluent_pages.__version__) < SV('1.1.3')) and
            'fluent_pages.pagetypes.redirectnode' in settings.INSTALLED_APPS
        ):
            from fluent_pages.pagetypes.redirectnode.admin \
                import RedirectNodeAdmin
            if getattr(RedirectNodeAdmin, 'fieldsets', None):
                RedirectNodeAdmin.base_fieldsets = RedirectNodeAdmin.fieldsets
                RedirectNodeAdmin.fieldsets = None

        # Connect signal handlers.
        post_migrate.connect(update_site, sender=self)

        # Import plugins from installed apps.
        autodiscover_modules('plugins')
