from django.apps import apps

from rest_framework import serializers

from .models import CreatorBase, WorkCreator as WorkCreatorModel, \
    WorkImage as WorkImageModel, WorkImageType as WorkImageTypeModel


ImageModel = apps.get_model('icekit_plugins_image.Image')


class Creator(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = CreatorBase
        fields = (
            'url',
            'name_display',
        )
        extra_kwargs = {
            'url': {
                'lookup_field': 'slug',
                'view_name': 'gk_collections_creator',
            }
        }


class WorkCreator(serializers.HyperlinkedModelSerializer):
    """ Relationship between a work and a creator """
    creator = Creator()

    class Meta:
        model = WorkCreatorModel
        fields = (
            'creator',
            'role',
            'is_primary',
            'order',
        )


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
