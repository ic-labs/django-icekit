"""
App configuration for ``icekit`` app.
"""

# Register signal handlers, but avoid interacting with the database.
# See: https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready

from django.apps import AppConfig
from django.utils.module_loading import autodiscover_modules


class AppConfig(AppConfig):
    name = 'icekit'

    def ready(self):
        """
        Import plugins from installed apps.
        """
        autodiscover_modules('plugins')

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
