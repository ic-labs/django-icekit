from django.apps import apps

from rest_framework import serializers
from rest_framework.settings import api_settings
from rest_framework.validators import UniqueTogetherValidator
from drf_queryfields import QueryFieldsMixin

from icekit.api.base_serializers import ModelSubSerializer, \
    PolymorphicHyperlinkedModelSerializer, WritableSerializerHelperMixin, \
    WritableRelatedFieldSettings
from icekit.api.images.serializers import RelatedImageSerializer

from .models import WorkBase, CreatorBase, WorkCreator as WorkCreatorModel, \
    WorkImage as WorkImageModel, WorkImageType as WorkImageTypeModel, \
    Role as RoleModel
from .plugins.moving_image.models import Rating as RatingModel, \
    Genre as GenreModel, MediaType as MediaTypeModel, \
    MovingImageWork as MovingImageWorkModel


class BaseCollectionModelSerializerMixin(QueryFieldsMixin):
    """
    Mixin with convienient features used by serializers for underlying
    `WorkBase` and `CreatorBase` serialization.

    Includes:
        - filter API results by fields, via djangorestframework-queryfields
        - avoid 'slug' fields always being required when we don't want this.
    """

    def get_validators(self):
        """
        Override default validators in DRF to disable checking of unique-
        together constraints that include the 'slug' because this check in
        the API effectively makes 'slug' a required field when we do not want
        it to be.
        """
        disabled_fields = set(getattr(
            self.Meta, 'disable_unique_together_constraint_fields', []))
        initial_data_keys = set(self.initial_data.keys())
        validators = super(BaseCollectionModelSerializerMixin, self) \
            .get_validators()
        validators = [
            v for v in validators
            # Only disable validation in specific case where it would apply
            # unique-together checks including the disabled fields where that
            # field is not present in the available data.
            if not(
                type(v) == UniqueTogetherValidator and
                disabled_fields.issubset(set(v.fields)) and
                not disabled_fields.intersection(initial_data_keys)
            )
        ]
        return validators


class CreatorSummary(PolymorphicHyperlinkedModelSerializer):
    """ Minimal information about a creator """

    def get_child_view_name_data(self):
        from .plugins.organization import api as organization_api
        from .plugins.person import api as person_api
        return {
            person_api.PersonCreatorModel: person_api.VIEWNAME,
            organization_api.OrganizationCreatorModel:
                organization_api.VIEWNAME,
        }

    class Meta:
        model = CreatorBase
        fields = (
            api_settings.URL_FIELD_NAME,
            'id',
            'name_display',
        )
        extra_kwargs = {
            'id': {
                'read_only': False,
            },
            'name_display': {
                'required': False,
                'read_only': True,
            },
        }


class WorkDate(ModelSubSerializer):
    class Meta:
        model = WorkBase
        source_prefix = 'date_'
        fields = (
            'date_display',
            'date_edtf',
        )


class WorkSummary(WritableSerializerHelperMixin,
                  PolymorphicHyperlinkedModelSerializer):
    """ Minimal information about a work """
    date = WorkDate(
        required=False,
        read_only=True,
    )

    def get_child_view_name_data(self):
        from .plugins.game import api as game_api
        from .plugins.film import api as film_api
        from .plugins.artwork import api as artwork_api
        return {
            game_api.GameModel: game_api.VIEWNAME,
            film_api.FilmModel: film_api.VIEWNAME,
            artwork_api.ArtworkModel: artwork_api.VIEWNAME,
        }

    class Meta:
        model = WorkBase
        fields = (
            api_settings.URL_FIELD_NAME,
            'id',
            'title',
            'date',
        )
        extra_kwargs = {
            'id': {
                'read_only': False,
            },
            'title': {
                'required': False,
                'read_only': True,
            },
        }


class Role(serializers.ModelSerializer):
    class Meta:
        model = RoleModel
        fields = (
            'slug',
            'title',
            'title_plural',
            'past_tense',
        )
        extra_kwargs = {
            'title': {
                'required': False,
            },
            'past_tense': {
                'required': False,
            },
        }


class WorkCreator(BaseCollectionModelSerializerMixin,
                  WritableSerializerHelperMixin,
                  serializers.HyperlinkedModelSerializer):
    """ Relationship between a work and a creator """
    work = WorkSummary()
    creator = CreatorSummary()
    role = Role(
        required=False,
        allow_null=True,
    )

    class Meta:
        model = WorkCreatorModel
        fields = (
            api_settings.URL_FIELD_NAME,
            'id',
            'work',
            'creator',
            'role',
            'is_primary',
            'order',
        )
        extra_kwargs = {
            api_settings.URL_FIELD_NAME: {
                'lookup_field': 'pk',
                'view_name': 'api:workcreator-api-detail',
            },
        }
        writable_related_fields = {
            'work': WritableRelatedFieldSettings(),
            'creator': WritableRelatedFieldSettings(),
            'role': WritableRelatedFieldSettings(
                lookup_field='slug', can_create=True),
        }
        disable_unique_together_constraint_fields = ['role']


class WorkCreatorFromWork(WorkCreator):
    """ Relationship from a work to its creators """
    class Meta:
        model = WorkCreatorModel
        # All fields from base WorkCreator except 'work' which is redundant
        fields = [
            f for f in WorkCreator.Meta.fields
            if f != 'work'
        ]


class WorkCreatorFromCreator(WorkCreator):
    """ Relationship from a creator to their works """
    class Meta:
        model = WorkCreatorModel
        # All fields from base WorkCreator except 'creator' which is redundant
        fields = [
            f for f in WorkCreator.Meta.fields
            if f != 'creator'
        ]


class Creator(BaseCollectionModelSerializerMixin,
              WritableSerializerHelperMixin,
              serializers.HyperlinkedModelSerializer):
    works = WorkCreatorFromCreator(
        source='workcreator_set',
        many=True,
        read_only=True,
    )
    portrait = RelatedImageSerializer(
        required=False,
    )

    class Meta:
        model = CreatorBase
        fields = (
            # Relationships
            'works',
            'portrait',
            # Fields
            api_settings.URL_FIELD_NAME,
            'publishing_is_draft',
            'slug',
            'alt_slug',
            'name_full',
            'name_display',
            'name_sort',
            'website',
            'wikipedia_link',
            # Metadata fields
            'id',
            'external_identifier',
            'dt_created',
            'dt_modified',
            'admin_notes',
        )
        extra_kwargs = {
            # Slug and name fields derived from `name_full` are not required
            'slug': {
                # NOTE: See also
                # `BaseCollectionModelSerializerMixin.get_validators()`
                'required': False,
            },
            'name_display': {
                'required': False,
            },
            'name_sort': {
                'required': False,
            },
        }
        writable_related_fields = {
            'portrait': WritableRelatedFieldSettings(can_create=True),
        }
        disable_unique_together_constraint_fields = ['slug']


class WorkOrigin(ModelSubSerializer):
    origin_country = serializers.SerializerMethodField()

    def get_country(self, obj):
        return obj.origin_country.name

    class Meta:
        model = WorkBase
        source_prefix = 'origin_'
        fields = (
            'origin_continent',
            'origin_country',
            'origin_state_province',
            'origin_city',
            'origin_neighborhood',
            'origin_colloquial',
        )


class WorkImageType(serializers.ModelSerializer):
    class Meta:
        model = WorkImageTypeModel
        fields = (
            'title',
            'slug',
        )


class WorkImage(WritableSerializerHelperMixin,
                serializers.ModelSerializer):
    image = RelatedImageSerializer(
        required=False,
    )
    image_type = WorkImageType(
        source='type',
        required=False,
    )

    class Meta:
        model = WorkImageModel
        ordering = ("order", )
        fields = (
            'image',
            'show_title',
            'show_caption',
            'title_override',
            'caption_override',
            'order',
            'image_type',
        )
        writable_related_fields = {
            'image': WritableRelatedFieldSettings(),
            'image_type': WritableRelatedFieldSettings(),
        }


class Work(BaseCollectionModelSerializerMixin,
           WritableSerializerHelperMixin,
           serializers.HyperlinkedModelSerializer):
    creators = WorkCreatorFromWork(
        source='workcreator_set',
        many=True,
        read_only=True,
    )
    images = WorkImage(
        source="workimage_set",
        many=True,
        read_only=True,
    )
    date = WorkDate(
        required=False,
    )
    origin = WorkOrigin(
        required=False,
    )

    class Meta:
        model = WorkBase
        fields = (
            # Relationships
            'creators',
            'images',
            # Sub-resources
            'date',
            'origin',
            # Fields
            api_settings.URL_FIELD_NAME,
            'publishing_is_draft',
            'slug',
            'title',
            'subtitle',
            'oneliner',
            'department',
            'credit_line',
            'accession_number',
            # Metadata fields
            'id',
            'external_identifier',
            'dt_created',
            'dt_modified',
            'admin_notes',
        )
        extra_kwargs = {
            # Slug and name fields derived from `name_full` are not required
            'slug': {
                # NOTE: See also
                # `BaseCollectionModelSerializerMixin.get_validators()`
                'required': False,
            },
        }
        disable_unique_together_constraint_fields = ['slug']


class Rating(serializers.ModelSerializer):
    class Meta:
        model = RatingModel
        fields = (
            'title',
            'slug',
            'image',
        )
        extra_kwargs = {
            'title': {
                'required': False,
            },
            'image': {
                'required': False,
            },
        }


class Genre(serializers.ModelSerializer):
    class Meta:
        model = GenreModel
        fields = (
            'title',
            'slug',
        )


class MediaType(serializers.ModelSerializer):
    class Meta:
        model = MediaTypeModel
        fields = (
            'title',
            'slug',
        )
        extra_kwargs = {
            'title': {
                'required': False,
            },
        }


class MovingImageWork(Work):
    rating = Rating(
        required=False,
    )
    genres = Genre(
        many=True,
        read_only=True,
    )
    media_type = MediaType(
        required=False,
    )

    class Meta:
        model = MovingImageWorkModel
        fields = Work.Meta.fields + (
            # Relationships
            'rating',
            'genres',
            'media_type',
            # Fields
            'rating_annotation',
            'duration_minutes',
            'trailer',
            'imdb_link',
        )
        extra_kwargs = Work.Meta.extra_kwargs
        writable_related_fields = {
            'rating': WritableRelatedFieldSettings(
                lookup_field='slug', can_create=True, can_update=False),
            'media_type': WritableRelatedFieldSettings(
                lookup_field='slug', can_create=True, can_update=False),
        }
