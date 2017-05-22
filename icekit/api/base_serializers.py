from collections import OrderedDict

import attr

from rest_framework import serializers
from rest_framework.relations import HyperlinkedIdentityField


class ModelSubSerializer(serializers.ModelSerializer):
    """
    ModelSubSerializer allows you to wrap related attributes of a model into a
    sub-model dict, that uses the same model.

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

    def get_fields(self):
        """
        Convert default field names for this sub-serializer into versions where
        the field name has the prefix removed, but each field object knows the
        real model field name by setting the field's `source` attribute.
        """
        prefix = getattr(self.Meta, 'source_prefix', '')
        fields = super(ModelSubSerializer, self).get_fields()
        fields_without_prefix = OrderedDict()
        for field_name, field in fields.items():
            if field_name.startswith(prefix):
                # Set real model field name as field's `source` unless the
                # source is already explicitly set, in which case it is
                # probably a method name not the direct field name
                if not field.source:
                    field.source = field_name
                field_name = field_name[len(prefix):]
            fields_without_prefix[field_name] = field
        return fields_without_prefix

    def get_attribute(self, instance):
        # This serializer also uses the same instance as the parent - we're
        # just wrapping related fields into a sub-object.
        return instance


@attr.s
class WritableRelatedFieldSettings(object):
    """
    """
    lookup_field = attr.ib(default='id')
    can_create = attr.ib(default=False)
    can_update = attr.ib(default=False)


class WritableSerializerHelperMixin(object):
    """
    Mixin class to apply to parent serializers that *use* `ModelSerializer`
    and `ModelSubSerializer` related/relationship fields to make them able to
    handle create/update write operations on these fields with minimal extra
    code, to avoid failures like:

        The `.update()` method does not support writable nested fields by default.
        Write an explicit `.update()` method for serializer...

    `ModelSubSerializer` fields which are used merely for grouping of parent
    fields into a sub-secion are handled automatically.

    `ModelSerializer` fields must be explicitly configured to work by defining
    a `writable_related_fields` settings dictionary in the parent serializer's
    `Meta` class, mapping relationship field names to
    `WritableRelatedFieldSettings` values like so:

        class MySerializer(ModelSerializer):
            related_1 = AnotherModelSerializer()
            related_2 = AnotherModelSerializer(read_only=True)

            class Meta:
                model = MyModel
                fields = ('related',)
                writable_related_fields = {
                    'related_1': WritableRelatedFieldSettings(
                        can_create=False, can_update=True)
                }
    """

    def _populate_validated_data_with_sub_field_data(self, validated_data):
        """
        Move field data nested in `ModelSubSerializer` fields back into the
        overall validated data dict.
        """
        for fieldname, field in self.get_fields().items():
            if isinstance(field, ModelSubSerializer):
                field_data = validated_data.pop(fieldname, None)
                if field_data:
                    validated_data.update(field_data)

    def _get_or_create_related_model_instances(self, validated_data):
        """
        """
        writable_related_fields = getattr(
            self.Meta, 'writable_related_fields', {})
        for fieldname, field in self.get_fields().items():
            if (
                not isinstance(field, serializers.ModelSerializer) or
                # `ModelSubSerializer` is handled separately
                isinstance(field, ModelSubSerializer) or
                field.read_only
            ):
                continue  # Skip field

            ModelClass = field.Meta.model
            field_data = validated_data.pop(fieldname, None)

            # Skip field if no data was provided
            if field_data is None:
                continue

            # Get settings for writable related field
            if fieldname not in writable_related_fields:
                raise TypeError(
                    "Cannot write related model field '%s' for %s on %s"
                    " without corresponding 'writable_related_fields' settings"
                    " in the Meta class"
                    % (fieldname, ModelClass.__name__,
                       self.Meta.model.__name__)
                )
            field_settings = writable_related_fields[fieldname]
            if not isinstance(field_settings, WritableRelatedFieldSettings):
                raise TypeError(
                    "Settings for related model field '%s' in"
                    " '%s.Meta.writable_related_fields' must be of type"
                    " 'WritableRelatedFieldSettings': %s"
                    % (fieldname, ModelClass.__name__, type(field_settings))
                )

            # Get settings for lookup field
            lookup_field = field_settings.lookup_field
            try:
                lookup_value = field_data.pop(lookup_field)
            except KeyError:
                raise TypeError(
                    "Cannot look up related model field '%s' for %s on %s"
                    " using '%s' as the lookup field because no value"
                    " for this field was provided in %s"
                    % (fieldname, ModelClass.__name__,
                        self.Meta.model.__name__, lookup_field, field_data)
                )

            # Fetch existing instance using lookup field
            try:
                related_instance = ModelClass.objects.get(
                    **{lookup_field: lookup_value})

                # Update existing related instance with values provided in
                # parent's create/update operation, if such updates are
                # permitted. If updates are not permitted, raise an exception
                # only if submitted values differ from existing ones.
                is_updated = False
                for name, value in field_data.items():
                    original_value = getattr(related_instance, name)
                    if value != original_value:
                        if not field_settings.can_update:
                            raise TypeError(
                                u"Cannot update instance for related model"
                                u" field '%s' for %s on %s because"
                                u" 'can_update' is not set for this field in"
                                u" 'writable_related_fields' but submitted"
                                u" value `%s=%s` does not match existing"
                                u" instance value `%s`"
                                % (fieldname, ModelClass.__name__,
                                   self.Meta.model.__name__, name, value,
                                   original_value)
                            )
                        setattr(related_instance, name, value)
                        is_updated = True
                if is_updated:
                    related_instance.save()
            except ModelClass.MultipleObjectsReturned, ex:
                raise TypeError(
                    "Cannot look up related model field '%s' for %s on %s"
                    " using '%s' as the lookup field because it returns"
                    " multiple results for value '%s': %s"
                    % (fieldname, ModelClass.__name__,
                       self.Meta.model.__name__, lookup_field, lookup_value,
                       ex)
                )
            # If a related instance does not yet exist, optionally create one
            except ModelClass.DoesNotExist:
                if not field_settings.can_create:
                    raise TypeError(
                        "Cannot create instance for related model field '%s'"
                        " for %s on %s because 'can_create' is not set for"
                        " this field in 'writable_related_fields'"
                        % (fieldname, ModelClass.__name__,
                           self.Meta.model.__name__)
                    )

                field_data.update({lookup_field: lookup_value})
                related_instance = ModelClass.objects.create(**field_data)

            # Add related model instance as validated data parameter for
            # later create/update operation on parent instance.
            validated_data[fieldname] = related_instance

    def create(self, validated_data):
        self._populate_validated_data_with_sub_field_data(validated_data)
        self._get_or_create_related_model_instances(validated_data)
        return super(WritableSerializerHelperMixin, self).create(
            validated_data)

    def update(self, instance, validated_data):
        self._populate_validated_data_with_sub_field_data(validated_data)
        self._get_or_create_related_model_instances(validated_data)
        return super(WritableSerializerHelperMixin, self).update(
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
