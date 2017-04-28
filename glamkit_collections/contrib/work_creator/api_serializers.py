from django.apps import apps

from rest_framework import serializers
from rest_framework.settings import api_settings

from icekit.api.base_serializers import ModelSubSerializer, \
    PolymorphicHyperlinkedModelSerializer, \
    PolymorphicHyperlinkedRelatedField, \
    ModelSubSerializerParentMixin

from .models import WorkBase, CreatorBase, WorkCreator as WorkCreatorModel, \
    WorkImage as WorkImageModel, WorkImageType as WorkImageTypeModel, \
    Role as RoleModel
from .plugins.moving_image.models import Rating as RatingModel, \
    Genre as GenreModel, MediaType as MediaTypeModel, \
    MovingImageWork as MovingImageWorkModel


ImageModel = apps.get_model('icekit_plugins_image.Image')


class Image(serializers.ModelSerializer):
    class Meta:
        model = ImageModel
        fields = (
            'image',
            'width',
            'height',
            'title',
            'caption',
            'credit',
            'source',
            'license',
            'notes',
            'is_ok_for_web',
        )


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


class WorkSummary(ModelSubSerializerParentMixin,
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


class WorkCreator(ModelSubSerializerParentMixin,
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


class Creator(ModelSubSerializerParentMixin,
              serializers.HyperlinkedModelSerializer):
    works = WorkCreatorFromCreator(
        source='workcreator_set',
        many=True,
        read_only=True,
    )
    portrait = Image()

    class Meta:
        model = CreatorBase
        fields = (
            # Relationships
            'works',
            'portrait',
            # Sub-resources
            # Fields
            api_settings.URL_FIELD_NAME,
            'slug',
            'alt_slug',
            'name_display',
            'name_sort',
            'website',
            'wikipedia_link',
            'admin_notes',
        )


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


class WorkImage(ModelSubSerializerParentMixin,
                serializers.ModelSerializer):
    image = Image()
    image_type = WorkImageType(
        source='type',
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


class Work(ModelSubSerializerParentMixin,
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
    date = WorkDate()
    origin = WorkOrigin()

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


class MovingImageWork(Work):
    rating = Rating()
    genres = Genre(
        many=True,
        read_only=True,
    )
    media_type = MediaType()

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
