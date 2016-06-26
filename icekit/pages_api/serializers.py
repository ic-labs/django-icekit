from fluent_pages.models import Page
from rest_framework import serializers


class ContentSerializer(serializers.Serializer):
    """
    A serializer to render content items for a fluent page.
    """
    content = serializers.SerializerMethodField()

    def get_content(self, obj):
        return obj.plugin.render(self.context['request'], obj)


class PageSerializer(serializers.ModelSerializer):
    """
    A serializer for a fluent page.
    """
    url = serializers.CharField(
        source='get_absolute_url',
        read_only=True
    )
    content = serializers.SerializerMethodField()

    class Meta:
        model = Page
        fields = ['id', 'url', 'title', 'status', 'parent', 'content', ]

    def get_content(self, obj):
        """
        Obtain the QuerySet of content items.
        :param obj: Page object.
        :return: List of rendered content items.
        """
        serializer = ContentSerializer(
            instance=obj.contentitem_set.all(),
            many=True,
            context=self.context,
        )
        return serializer.data
