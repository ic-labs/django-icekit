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

        def get_related_model_objects(name, super_func):
            """
            Obtains the related model objects based upon the slot name.

            If the related model does not exist it will call the
            `super_func` function with the slot name so super can be
            called if desired or appropriate functionality implemented
            such as raising an exception.

            :param name: The slot name in string form.
            :param super_func: A function that that has not been called
            which accepts at least one argument. The slot name will be
            passed to the function.
            :returns; Related model contents if they exist or what has
            been defined in `super_func`.
            """
            try:
                # Parent type, parent id and slot are set to be unique on the default
                # related model and therefore treated as such here.
                return related_model.objects.get(
                    parent_type=ContentType.objects.get_for_model(type(instance)),
                    parent_id=instance.id,
                    slot=name,
                ).get_content_items()
            except related_model.DoesNotExist:
                return super_func(name)

        class PlaceholderAccess(object):
            def __getattribute__(self, name):
                """
                Allow placeholder contents to be accessed via slot
                name on the descriptor object.

                For example if the slot was named `main` and you had
                a descriptor named `slots` on an object named `page`
                you would call it by `page.slots.main`.

                If a slot name is used that does not exist an
                `AttributeError` will be raised.
                """
                return get_related_model_objects(
                    name,
                    super(PlaceholderAccess, self).__getattribute__
                )

            def __getitem__(self, item):
                """
                Allow placeholder contents to be accessed via slot
                name one the descriptor object via a dictionary
                lookup.

                For example if the slot was named `main` and you had
                a descriptor named `slots` on an object named `page`
                you would call it by `page.slots['main']`.

                If a slot name is used that does not exist a
                `KeyError` will be raised.
                """
                def raise_key_error(name):
                    """
                    Helper function to raise a `KeyError`.
                    """
                    raise KeyError()

                return get_related_model_objects(
                    item,
                    raise_key_error
                )

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
