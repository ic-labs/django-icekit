from rest_framework import routers
from rest_framework import serializers

from icekit.api.base_views import ModelViewSet

from ...api_serializers import Creator
from .models import OrganizationCreator as OrganizationCreatorModel


VIEWNAME = 'api:organization-api'


class Organization(Creator):
    type = serializers.SerializerMethodField()
    type_plural = serializers.SerializerMethodField()
    # Rename start/end date creator fields to creation/closure for organization
    creation_date_display = serializers.CharField(
        source='start_date_display',
        required=False,
        allow_blank=True,
    )
    creation_date_edtf = serializers.CharField(
        source='start_date_edtf',
        required=False,
        allow_blank=True,
        allow_null=True,
    )
    closure_date_display = serializers.CharField(
        source='end_date_display',
        required=False,
        allow_blank=True,
    )
    closure_date_edtf = serializers.CharField(
        source='end_date_edtf',
        required=False,
        allow_blank=True,
        allow_null=True,
    )

    class Meta:
        model = OrganizationCreatorModel
        # Use Creator field names except for those for start/end dates which we
        # rename to creation/closure
        _creator_fields = tuple(
            f for f in Creator.Meta.fields
            if (
                not f.startswith('start_date_') and
                not f.startswith('end_date_')
            )
        )
        fields = _creator_fields + (
            'type',
            'type_plural',
            'creation_date_display',
            'creation_date_edtf',
            'closure_date_display',
            'closure_date_edtf',
        )
        extra_kwargs = dict(Creator.Meta.extra_kwargs, **{
            'url': {
                'lookup_field': 'pk',
                'view_name': '%s-detail' % VIEWNAME,
            }
        })
        writable_related_fields = Creator.Meta.writable_related_fields

    def get_type(self, obj):
        return obj.get_type()

    def get_type_plural(self, obj):
        return obj.get_type_plural()


class APIViewSet(ModelViewSet):
    """
    Organization resource.
    """
    queryset = OrganizationCreatorModel.objects.all()
    serializer_class = Organization


router = routers.DefaultRouter()
router.register('organization', APIViewSet, VIEWNAME)
