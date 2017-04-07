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
