from collections import OrderedDict

from rest_framework import serializers
from rest_framework.relations import HyperlinkedIdentityField


class ModelSubSerializer(serializers.ModelSerializer):
    """
    ModelSubSerializer allows you to wrap related attributes of a model into a
    sub-model dict, that uses the same model. Works read-only for now.

    Use ModelSubSerializer, rather than just populating a dict, for more
    rigorous specification and (hence) better Swagger-generated documentation.

    example usage:

    class Biography(ModelSubSerializer):
        class Meta:
            source_prefix = 'biography_' # 'biography_' is stripped from keys
            model = ArtistModel
            fields = (
                'biography_html',
            )

    class Artist(serializers.HyperlinkedModelSerializer):
        ...
        name = CharField()
        biography = Biography(help_text="HTML and text forms of the biography")
        ...

        class Meta:
            model = ArtistModel
            ...

    Yields, in an api response:

    {
        ...
        name: 'foo'
        biography: {
            html: "bar",
            text: "woo"
        },
        ...
    }


    """

    def to_representation(self, instance):
        """Strips Meta.source_prefix from the front of keys"""
        prefix = getattr(self.Meta, 'source_prefix', '')
        default_rep = super(ModelSubSerializer, self)\
            .to_representation(instance)
        return OrderedDict([
            (k[len(prefix):], v)
            if k.startswith(prefix) else (k, v) for k, v in default_rep.items()
        ])

    def get_attribute(self, instance):
        # This serializer also uses the same instance as the parent - we're
        # just wrapping related fields into a sub-object.
        return instance


class ModelSubSerializerParentMixin(object):
    """
    Mixin class to apply to serializers that *use* `ModelSubSerializer` fields
    to group data, so they can handle create & update write operations on these
    fields without failing with errors like:

        The `.update()` method does not support writable nested fields by default.
        Write an explicit `.update()` method for serializer...
    """

    def _populate_validated_data_with_sub_field_data(self, validated_data):
        """
        Move field data nested in `ModelSubSerializer` fields back into the
        overall validated data dict.
        """
        for fieldname, field in self.get_fields().items():
            if isinstance(field, ModelSubSerializer):
                field_data = validated_data.pop(fieldname)
                validated_data.update(field_data)

    def create(self, validated_data):
        self._populate_validated_data_with_sub_field_data(validated_data)
        return super(ModelSubSerializerParentMixin, self).create(
            validated_data)

    def update(self, instance, validated_data):
        self._populate_validated_data_with_sub_field_data(validated_data)
        return super(ModelSubSerializerParentMixin, self).update(
            instance, validated_data)


class PolymorphicHyperlinkedRelatedField(HyperlinkedIdentityField):
    """
    Custom `HyperlinkedIdentityField` that allows the lookup view name for a
    hyperlink identify field (usually 'url') to be changed dynamically via
    `get_child_detail_view_name` in the parent serializer.
    """

    def get_url(self, obj, view_name, request, format):
        serializer = self.parent
        override_view_name = serializer.get_child_detail_view_name(obj)
        return super(PolymorphicHyperlinkedRelatedField, self) \
            .get_url(obj, override_view_name, request, format)


class PolymorphicHyperlinkedModelSerializer(
        serializers.HyperlinkedModelSerializer
):
    """
    Custom `HyperlinkedModelSerializer` that permits the lookup view name for
    the `url` field to be changed dynamically based on a lookup dict returned
    from the `get_child_view_name_data` method.

    This class combined with `PolymorphicHyperlinkedRelatedField` allows us to
    return data for polymorphic parent models by providing a manual lookup
    table of child-items to view names.
    """
    serializer_url_field = PolymorphicHyperlinkedRelatedField

    def get_child_detail_view_name(self, obj):
        real_obj = obj.get_real_instance()
        return self.get_child_view_name_data().get(
            type(real_obj),
            'TODO-add-child-detail-view-name-for-type-%s' % type(real_obj)
        ) + '-detail'

    def get_child_view_name_data(self, obj):
        raise NotImplementedError(
            "%s must implement `get_child_view_name_data`" % type(self))
