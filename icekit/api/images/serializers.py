from django.apps import apps

from rest_framework import serializers

from icekit.api.base_serializers import WritableSerializerHelperMixin, \
    WritableRelatedFieldSettings


Image = apps.get_model('icekit_plugins_image.Image')
MediaCategory = apps.get_model('icekit.MediaCategory')


class MediaCategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = MediaCategory
        fields = ['id', 'name']
        extra_kwargs = {
            'id': {
                'read_only': False,
                'required': False,
            },
            'name': {
                'read_only': False,
                'required': False,
            },
        }


class ImageSerializer(
        WritableSerializerHelperMixin, serializers.ModelSerializer
):
    """
    A serializer for an ICEkit Image.
    """
    categories = MediaCategorySerializer(
        many=True,
    )

    class Meta:
        model = Image
        fields = ['id', 'image', 'width', 'height', 'title', 'alt_text',
                  'caption', 'credit', 'source', 'external_ref', 'categories',
                  'license', 'notes', 'date_created', 'date_modified',
                  'is_ok_for_web', 'is_cropping_allowed']
        writable_related_fields = {
            'categories': WritableRelatedFieldSettings(
                can_create=True, can_update=True),
        }


# TODO It is probably not a good idea to allow API user to set auto-gen ID
# field, but this is the only way I have found (so far) to allow ID to be
# passed through API to relate existing images.
class RelatedImageSerializer(ImageSerializer):
    """
    A serializer for an ICEkit Image relationships that exposes the ID primary
    key field to permit referring to existing images by ID, instead of needing
    to upload an actual image file every time.
    """
    class Meta(ImageSerializer.Meta):
        extra_kwargs = {
            'id': {
                'read_only': False,
                'required': False,
            },
            'image': {
                'required': False,
            }
        }
