from django.apps import apps

from rest_framework import serializers
from rest_framework.settings import api_settings
from rest_framework.validators import UniqueTogetherValidator

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
            'name_display',
        )


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
    date = WorkDate()

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
            'title',
            'date',
        )


class Role(serializers.ModelSerializer):
    class Meta:
        model = RoleModel
        fields = (
            'slug',
            'title',
            'title_plural',
            'past_tense',
        )


class WorkCreator(WritableSerializerHelperMixin,
                  serializers.HyperlinkedModelSerializer):
    """ Relationship between a work and a creator """
    work = WorkSummary()
    creator = CreatorSummary()
    role = Role()

    class Meta:
        model = WorkCreatorModel
        fields = (
            'work',
            'creator',
            'role',
            'is_primary',
            'order',
        )
        writable_related_fields = {
            'work': WritableRelatedFieldSettings(),
            'creator': WritableRelatedFieldSettings(),
            'role': WritableRelatedFieldSettings(),
        }


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


class Creator(WritableSerializerHelperMixin,
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
            'admin_notes',
        )
        extra_kwargs = {
            # Slug and name fields derived from `name_full` are not required
            'slug': {
                # NOTE: See extra work in `get_validators` to prevent DRF from
                # requiring the 'slug field despite our explicit setting here.
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

    def get_validators(self):
        """
        Override default validators in DRF to disable checking of unique-
        together constraints that include the 'slug' because this check in
        the API effectively makes 'slug' a required field when we do not want
        it to be.
        """
        validators = super(Creator, self).get_validators()
        validators = [
            v for v in validators
            # Only disable validation in specific case where it would apply
            # unique-together checks including the 'slug' field where that
            # field is not present in the available data.
            if not(
                type(v) == UniqueTogetherValidator and
                'slug' in v.fields and
                'slug' not in self.initial_data
            )
        ]
        return validators


class WorkOrigin(ModelSubSerializer):
    origin_country = serializers.SerializerMethodField()

    def get_origin_country(self, obj):
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


class Work(WritableSerializerHelperMixin,
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
        )


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
        writable_related_fields = {
            'rating': WritableRelatedFieldSettings(
                lookup_field='slug', can_create=True, can_update=False),
            'media_type': WritableRelatedFieldSettings(
                lookup_field='slug', can_create=True, can_update=False),
        }
