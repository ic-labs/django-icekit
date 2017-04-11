from rest_framework import routers
from rest_framework import serializers

from icekit.api.base_views import RedirectViewset

from ...api_serializers import Creator
from .models import OrganizationCreator as OrganizationCreatorModel


class Organization(Creator):
    type = serializers.SerializerMethodField()
    type_plural = serializers.SerializerMethodField()

    class Meta:
        model = OrganizationCreatorModel
        fields = Creator.Meta.fields + (
            'type',
            'type_plural',
        )
        extra_kwargs = Creator.Meta.extra_kwargs

    def get_type(self, obj):
        return obj.get_type()

    def get_type_plural(self, obj):
        return obj.get_type_plural()


class APIViewSet(RedirectViewset):
    """
    Organization resource.
    """
    queryset = OrganizationCreatorModel.objects.all()
    serializer_class = Organization


router = routers.DefaultRouter()
router.register('organization', APIViewSet, 'organization-api')
