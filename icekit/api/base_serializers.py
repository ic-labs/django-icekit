from collections import OrderedDict

import attr

from rest_framework import serializers
from rest_framework.relations import HyperlinkedIdentityField
from rest_framework.validators import UniqueValidator, UniqueTogetherValidator


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
    - lookup_field: a field name, or list of field names, that uniquely
      identify an instance and will be used to look up an existing instance
      based on data provided. If a list of field names is provided, the first
      field name matching a provided value will be used.
    - can_create: ``True`` means new instances can be created for the field
    - can_update: ``True`` means instances can be updated for the field
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

    def _prepare_related_single_or_m2m_relations(self, validated_data):
        """
        Handle writing to nested related model fields for both single and
        many-to-many relationships.

        For single relationships, any existing or new instance resulting from
        the provided data is set back into the provided `validated_data` to
        be applied by DjangoRestFramework's default handling.

        For M2M relationships, any existing or new instances resulting from
        the provided data are returned in a dictionary mapping M2M field names
        to a list of instances to be related. The actual relationship is then
        applied by `_write_related_m2m_relations` because DjangoRestFramework
        does not support assigning M2M fields.
        """
        many_to_many_relationships = {}
        for fieldname, field in self.get_fields().items():
            if (
                # `ModelSubSerializer` is handled separately
                isinstance(field, ModelSubSerializer) or
                # Skip read-only fields, obviously
                field.read_only or
                # Only list or model serializers are supported
                not (
                    isinstance(field, serializers.ModelSerializer) or
                    isinstance(field, serializers.ListSerializer)
                )
            ):
                continue  # Skip field

            is_list_field = isinstance(field, serializers.ListSerializer)

            if is_list_field:
                ModelClass = field.child.Meta.model
                field_data_list = validated_data.pop(fieldname, [])
            else:
                ModelClass = field.Meta.model
                field_data_list = validated_data.pop(fieldname, None)
                field_data_list = field_data_list and [field_data_list] or []

            # Skip field if no data was provided
            if not field_data_list:
                continue

            related_instances = []
            for field_data in field_data_list:
                related_instance = \
                    self._get_or_update_or_create_related_instance(
                        ModelClass, fieldname, field_data)
                if related_instance:
                    related_instances.append(related_instance)

            # Add related model instance as validated data parameter for
            # later create/update operation on parent instance.
            if not is_list_field:
                validated_data[fieldname] = related_instances[0]
            # Many-to-many relationships must be handled after super's `create`
            # or `update` method, not here. So we just return the list for now
            else:
                many_to_many_relationships[fieldname] = related_instances
        return many_to_many_relationships

    def _get_or_update_or_create_related_instance(
            self, ModelClass, fieldname, field_data
    ):
        """
        Handle lookup, update, or creation of related instances based on the
        field data provided and the field's `writable_related_fields` settings
        as defined on the serializer's `Meta`.

        This method will:

            - fail immediately if the field does not have
              `writable_related_fields` settings defined, or if these settings
              are not valid `WritableRelatedFieldSettings` objects

            - look up an existing instance using the defined `lookup_field` if
              a value is provided for the lookup field:

              - if no lookup field value is provided, fail unless `can_create`
                is set on the field since we cannot find any existing instance
              - if no existing instance is found, fail unless `can_create`
              - find the matching existing instance

            - if there is an existing instance:

              - if other data is provided, fail unless `can_update` is set
              - update existing instance based on other data provided if
                `can_update is set`
              - return the existing instance

            - if there is not an existing instance and `can_create` is set:

              - create a new instance with provided data
              - return the new instance
        """
        writable_related_fields = getattr(
            self.Meta, 'writable_related_fields', {})

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

        # Get settings for lookup field; may be a string or a strings list
        lookup_fields = field_settings.lookup_field
        if not isinstance(lookup_fields, (list, tuple)):
            lookup_fields = [lookup_fields]

        # We use the first of potentially multiple lookup field values for
        # which we have been given field data.
        lookup_value = None
        for lookup_field in lookup_fields:
            if lookup_field in field_data:
                lookup_value = field_data.pop(lookup_field)
                break

        # Fail if we have no lookup value and we cannot create an instance
        if lookup_value is None and not field_settings.can_create:
            raise TypeError(
                "Cannot look up related model field '%s' for %s on %s"
                " using the lookup field(s) %r because no value"
                " was provided for the lookup field(s) in %s"
                % (fieldname, ModelClass.__name__,
                    self.Meta.model.__name__, lookup_fields, field_data)
            )

        related_instance = None

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
                   self.Meta.model.__name__, lookup_field, lookup_value, ex)
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

        return related_instance

    def _write_related_m2m_relations(self, obj, many_to_many_relationships):
        """
        For the given `many_to_many_relationships` dict mapping field names to
        a list of object instances, apply the instance listing to the `obj`s
        named many-to-many relationship field.
        """
        for fieldname, related_objs in many_to_many_relationships.items():
            # TODO On PATCH avoid clearing existing relationships not provided?
            setattr(obj, fieldname, related_objs)

    def create(self, validated_data):
        self._populate_validated_data_with_sub_field_data(validated_data)
        m2m_rels = self._prepare_related_single_or_m2m_relations(
            validated_data)
        obj = super(WritableSerializerHelperMixin, self).create(
            validated_data)
        self._write_related_m2m_relations(obj, m2m_rels)
        return obj

    def update(self, instance, validated_data):
        self._populate_validated_data_with_sub_field_data(validated_data)
        m2m_rels = self._prepare_related_single_or_m2m_relations(
            validated_data)
        obj = super(WritableSerializerHelperMixin, self).update(
            instance, validated_data)
        self._write_related_m2m_relations(obj, m2m_rels)
        return obj


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


class DisableUniqueTogetherValidatorMixin(object):
    """
    Mixin to easily disable the problematic `UniqueTogetherValidator` from
    DjangoRestFramework that automatically applies unique-together constraints
    of model fields so early in request processing that it makes it impossible
    to have any custom handling of affected fields.

    This mixin can help avoid situations like an API field being required
    despite us explicitly setting it as not required, e.g. the `slug` field in
    GLAMkit Collection models.
    """

    def get_validators(self):
        validators = super(DisableUniqueTogetherValidatorMixin, self) \
            .get_validators()
        disable_unique_together_fields = set(getattr(
            self.Meta, 'disable_unique_together_constraint_fields', []))
        if disable_unique_together_fields:
            initial_data_keys = set(self.initial_data.keys())
            validators = [
                v for v in validators
                # Only disable validation in specific case where it would apply
                # unique-together checks including the disabled fields where
                # that field is not present in the available data.
                if not(
                    type(v) == UniqueTogetherValidator and
                    disable_unique_together_fields.issubset(set(v.fields)) and
                    not disable_unique_together_fields.intersection(
                        initial_data_keys)
                )
            ]
        return validators
