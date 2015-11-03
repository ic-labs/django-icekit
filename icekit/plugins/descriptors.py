from django.contrib.contenttypes.models import ContentType
from fluent_contents.models import Placeholder


class PlaceholderDescriptor(object):
    """
    Descriptor to append appropriate slot content to a `UrlNode` derivative.
    """
    place_holder_access = None

    def __init__(self, model=None):
        """
        """
        self.related_model = model or Placeholder

    def __get__(self, instance=None, cls=None):
        """
        Create placeholder access object.
        """
        if instance is None:
            return self

        if self.place_holder_access:
            return self.place_holder_access

        self.place_holder_access = self.create_placeholder_access_object(instance)
        return self.place_holder_access

    def contribute_to_class(self, cls, name):
        """
        Perform contriubtion to class.
        """
        self.name = name
        self.model_class = cls
        setattr(cls, self.name, self)

    def create_placeholder_access_object(self, instance):
        """
        Created objects with placeholder slots as properties.

        Each placeholder created for an object will be added to a
        `PlaceHolderAccess` object as a set property.
        """
        related_model = self.related_model

        class PlaceholderAccess(object):
            def __getattribute__(self, name):
                try:
                    # Parent type, parent id and slot are set to be unique on the default
                    # related model and therefore treated as such here.
                    return related_model.objects.get(
                        parent_type=ContentType.objects.get_for_model(type(instance)),
                        parent_id=instance.id,
                        slot=name,
                    ).get_content_items()
                except related_model.DoesNotExist:
                    return super(PlaceholderAccess, self).__getattribute__(name)

        return PlaceholderAccess()


def monkey_patch(model_class, name='slots', descriptor=None):
    """
    Monkey patching function that adds a description to a model Class.
    :param model_class: The model class the descriptor is to be added
    to.
    :param name: The attribute name the descriptor will be assigned to.
    :param descriptor: The descriptor instance to be used. If none is
    specified it will default to
    ``icekit.plugins.descriptors.PlaceholderDescriptor``.
    :return: True
    """
    rel_obj = descriptor or PlaceholderDescriptor()
    rel_obj.contribute_to_class(model_class, name)
    setattr(model_class, name, rel_obj)
    return True
