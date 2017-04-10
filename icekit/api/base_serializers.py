from collections import OrderedDict

from rest_framework import serializers


class ModelSubSerializer(serializers.ModelSerializer):
    """
    ModelSubSerializer allows you to wrap related attributes of a model into a
    sub-model dict, that uses the same model. Works read-only for now.

    Use ModelSubSerializer, rather than just populating a dict, for more
    rigorous specification and (hence) better Swagger-generated documentation.

    example usage:

    class Biography(ModelSubSerializer):
        class Meta:
            source_prefix = 'biography_' # 'biography_' is stripped from keys
            model = ArtistModel
            fields = (
                'biography_html',
            )

    class Artist(serializers.HyperlinkedModelSerializer):
        ...
        name = CharField()
        biography = Biography(help_text="HTML and text forms of the biography")
        ...

        class Meta:
            model = ArtistModel
            ...

    Yields, in an api response:

    {
        ...
        name: 'foo'
        biography: {
            html: "bar",
            text: "woo"
        },
        ...
    }


    """

    def to_representation(self, instance):
        """Strips Meta.source_prefix from the front of keys"""
        prefix = getattr(self.Meta, 'source_prefix', '')
        default_rep = super(ModelSubSerializer, self)\
            .to_representation(instance)
        return OrderedDict([
            (k[len(prefix):], v)
            if k.startswith(prefix) else (k, v) for k, v in default_rep.items()
        ])

    def get_attribute(self, instance):
        # This serializer also uses the same instance as the parent - we're
        # just wrapping related fields into a sub-object.
        return instance
