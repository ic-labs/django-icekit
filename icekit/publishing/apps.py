from django.apps import AppConfig, apps
from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType
from django.db.models.signals import post_migrate

from icekit.plugins import descriptors


def create_can_publish_permission(sender, **kwargs):
    """
    Add `can_publish` permission for each of the publishable model.
    """
    for model in sender.publishable_models:
        content_type = ContentType.objects.get_for_model(model)
        permission, created = Permission.objects.get_or_create(
            content_type=content_type, codename='can_publish',
            defaults=dict(name='Can Publish %s' % model.__name__))


class AppConfig(AppConfig):
    # Name of package where `apps` module is located
    name = '.'.join(__name__.split('.')[:-1])

    def __init__(self, *args, **kwargs):
        self.label = self.name.replace('.', '_')
        self.publishable_models = self.get_models_to_monkey_patch()
        super(AppConfig, self).__init__(*args, **kwargs)

    def get_models_to_monkey_patch(self):
        """
        Override to return custom publishable models for monkey patching.
        """
        return []

    def ready(self):
        # Check if `fluent_pages` is installed. If so let the "fun" begin.
        # This will help "patch" each of the managers to have the anticipated
        # manager methods.  Please note that in the `__init__.py` file there is
        # a class field injection function which adds additional fields to
        # UrlNode which allow `publisher` to work. These fields are a direct
        # copy from the `publisher` models. So if they change we will have
        # pain.  This is not a preferred solution at all.... it is quite
        # fragile, makes migrations on external applications (so we need to
        # bring the migrations in the project), and is quite difficult to
        # follow with lots of hackery. It is an interim solution to get us
        # unblocked and it should be addressed as soon as possible.
        if apps.is_installed('fluent_pages'):
            from fluent_pages.extensions import page_type_pool

            Page = apps.get_model('fluent_pages.Page')
            descriptors.contribute_to_class(Page)

            # We use the page type pools as a way of finding models to patch
            # into publishable ones, not because it makes 100% sense but
            # because it is a convenient collection of the models.
            # TODO Revisit this approach: can we just patch base or polymorphic
            # parent models rather than everything in the type pools?
            self.publishable_models += [
                plugin.model for plugin in page_type_pool.get_plugins()
            ]

            # Explicitly add publishable models that are not in a type pool
            UrlNode = apps.get_model('fluent_pages.UrlNode')
            self.publishable_models += [
                # Fluent base classes are not directly in type pool
                UrlNode, Page,
            ]

            from .managers import (
                PublisherManager,
                PublisherUrlNodeManager,
                PublisherContributeToClassManager,
            )

            # For each page type plugin and associated polymorphic fields we
            # need to patch the managers to have publishing features.
            for klass in self.publishable_models:
                # Replace default managers, as appropriate for UrlNode-based
                # classes or non-UrlNode-based classes.
                if issubclass(klass, UrlNode):
                    klass.add_to_class(
                        '_default_manager', PublisherUrlNodeManager())
                    klass.add_to_class(
                        'objects', PublisherUrlNodeManager())
                else:
                    klass.add_to_class(
                        '_default_manager', PublisherManager())
                    klass.add_to_class(
                        'objects', PublisherManager())

                # Contribute publisher attrs and methods to class
                klass.add_to_class(
                    '__publisher_manager', PublisherContributeToClassManager())

        post_migrate.connect(create_can_publish_permission, sender=self)
