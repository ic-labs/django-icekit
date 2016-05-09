from django.apps import AppConfig, apps

from .models import PublishableMPTTModelMixin, PublishableUrlNodeMixin


class AppConfig(AppConfig):
    # Name of package where `apps` module is located
    name = '.'.join(__name__.split('.')[:-1])

    def __init__(self, *args, **kwargs):
        self.label = self.name.replace('.', '_')
        super(AppConfig, self).__init__(*args, **kwargs)

    def ready(self):
        # Monkey-patch workaround for class inheritance weirdness where our
        # model methods and attributes are getting clobbered by versions higher
        # up the inheritance hierarchy.
        # TODO Find a way to avoid this monkey-patching hack
        for model in apps.get_models():
            if issubclass(model, PublishableMPTTModelMixin):
                model.get_root = PublishableMPTTModelMixin.get_root
                model.get_ancestors = PublishableMPTTModelMixin.get_ancestors
                model.get_descendants = \
                    PublishableMPTTModelMixin.get_descendants
            if issubclass(model, PublishableMPTTModelMixin):
                model._make_slug_unique = \
                    PublishableUrlNodeMixin._make_slug_unique
