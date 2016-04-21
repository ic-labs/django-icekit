from django.apps import AppConfig, apps

from .models import PublishableMPTTModelMixin


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
        for model in apps.get_models():
            if issubclass(model, PublishableMPTTModelMixin):
                model.get_root = PublishableMPTTModelMixin.get_root
