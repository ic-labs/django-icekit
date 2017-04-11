from django.apps import apps

from rest_framework import serializers
from rest_framework.settings import api_settings

from icekit.api.base_serializers import ModelSubSerializer

from .models import WorkBase, CreatorBase, WorkCreator as WorkCreatorModel, \
    WorkImage as WorkImageModel, WorkImageType as WorkImageTypeModel, \
    Role as RoleModel


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


class CreatorSummary(serializers.HyperlinkedModelSerializer):
    """ Minimal information about a creator """
    class Meta:
        model = CreatorBase
        fields = (
            api_settings.URL_FIELD_NAME,
            'name_display',
        )
        extra_kwargs = {
            'url': {
                'lookup_field': 'slug',
                'view_name': 'gk_collections_creator',
            }
        }


class WorkDate(ModelSubSerializer):
    class Meta:
        model = WorkBase
        source_prefix = 'date_'
        fields = (
            'date_display',
            'date_edtf',
        )


class WorkSummary(serializers.HyperlinkedModelSerializer):
    """ Minimal information about a work """
    date = WorkDate()

    class Meta:
        model = WorkBase
        fields = (
            api_settings.URL_FIELD_NAME,
            'title',
            'date',
        )
        extra_kwargs = {
            'url': {
                'lookup_field': 'slug',
                'view_name': 'gk_collections_work',
            }
        }


class Role(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = RoleModel
        fields = (
            'slug',
            'title',
            'title_plural',
            'past_tense',
        )


class WorkCreator(serializers.HyperlinkedModelSerializer):
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


class Creator(serializers.HyperlinkedModelSerializer):
    works = WorkCreator(
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
        extra_kwargs = {
            'url': {
                'lookup_field': 'slug',
                'view_name': 'gk_collections_creator',
            }
        }


class WorkOrigin(ModelSubSerializer):
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


class WorkImage(serializers.ModelSerializer):
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


class Work(serializers.HyperlinkedModelSerializer):
    creators = WorkCreator(
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
        extra_kwargs = {
            'url': {
                'lookup_field': 'slug',
                'view_name': 'gk_collections_work',
            }
        }
