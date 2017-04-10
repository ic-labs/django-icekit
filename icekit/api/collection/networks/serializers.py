from rest_framework import serializers

from sfmoma.getty.models import GettyArtistData


class ArtistNetwork(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = GettyArtistData
        fields = (
            'ulan',
            'artist_id',
            'getty_term',
            'relationships',
            'artist_slug',
        )
