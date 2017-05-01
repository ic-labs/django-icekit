from django.apps import apps

from rest_framework import serializers


Image = apps.get_model('icekit_plugins_image.Image')


class ImageSerializer(serializers.ModelSerializer):
    """
    A serializer for an ICEkit Image.
    """
    class Meta:
        model = Image
        fields = ['id', 'image', 'width', 'height', 'title', 'alt_text',
                  'caption', 'credit', 'source', 'external_ref', 'categories',
                  'license', 'notes', 'date_created', 'date_modified',
                  'is_ok_for_web', 'is_cropping_allowed']


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
