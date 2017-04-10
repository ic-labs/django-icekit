from rest_framework import serializers

from sfmoma.getty.models import GettyRelationships


class RelationshipDescriptions(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = GettyRelationships
        fields = (
            'id',
            'relationship_getty_name',
            'relatioship_description',
            'relationship_weight',
        )
