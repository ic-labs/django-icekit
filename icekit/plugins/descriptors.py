from django.contrib.contenttypes.models import ContentType
from fluent_contents.models import Placeholder


class SlotDescriptor(object):
    """
    Descriptor to append appropriate slot content to a `UrlNode` derivative.
    """
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

        return self.create_placeholder_access_object(instance)

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
        placeholders = self.related_model.objects.filter(
            parent_type=ContentType.objects.get_for_model(type(instance)),
            parent_id=instance.id,
        )

        class PlaceholderAccess(object):
            pass

        obj = PlaceholderAccess()

        for placeholder in placeholders:
            setattr(obj, placeholder.slot, placeholder.get_content_items())

        return obj


def monkey_patch(model_class, name='slots', descriptor=None):
    """
    Monkey patching function that adds a description to a model Class.
    :param model_class: The model class the descriptor is to be added
    to.
    :param name: The attribute name the descriptor will be assigned to.
    :param descriptor: The descriptor instance to be used. If none is
    specified it will default to
    ``icekit.plugins.descriptors.SlotDescriptor``.
    :return: True
    """
    rel_obj = descriptor or SlotDescriptor()
    rel_obj.contribute_to_class(model_class, name)
    setattr(model_class, name, rel_obj)
    return True
