from rest_framework import routers, serializers

from icekit.api.base_serializers import ModelSubSerializer
from icekit.api.base_views import ModelViewSet

from ...api_serializers import Creator
from .models import PersonCreator as PersonCreatorModel


VIEWNAME = 'api:person-api'


class PersonName(ModelSubSerializer):
    class Meta:
        model = PersonCreatorModel
        source_prefix = 'name_'
        fields = (
            'name_full',
            'name_display',
            'name_sort',
            'name_given',
            'name_family',
        )
        extra_kwargs = {
            # Name fields derived from `name_full` are not required
            'name_display': {
                'required': False,
            },
            'name_sort': {
                'required': False,
            },
        }


class Background(ModelSubSerializer):
    class Meta:
        model = PersonCreatorModel
        source_prefix = 'background_'
        fields = (
            'background_ethnicity',
            'background_nationality',
            'background_neighborhood',
            'background_city',
            'background_state_province',
            'background_country',
            'background_continent',
        )


class Person(Creator):
    name = PersonName(
        help_text="Parts and forms of the Artist's name",
    )
    background = Background(
        required=False,
        help_text="Ethnicity, nationality and culture",
    )
    # Rename start/end date creator fields to birth/death for person
    birth_date_display = serializers.CharField(
        source='start_date_display',
        required=False,
        allow_blank=True,
    )
    birth_date_edtf = serializers.CharField(
        source='start_date_edtf',
        required=False,
        allow_blank=True,
        allow_null=True,
    )
    death_date_display = serializers.CharField(
        source='end_date_display',
        required=False,
        allow_blank=True,
    )
    death_date_edtf = serializers.CharField(
        source='end_date_edtf',
        required=False,
        allow_blank=True,
        allow_null=True,
    )

    class Meta:
        model = PersonCreatorModel
        # Use Creator field names except for those grouped under PersonName
        # and those for start/end dates which we rename to birth/death
        _creator_fields = tuple(
            f for f in Creator.Meta.fields
            if (
                f not in PersonName.Meta.fields and
                not f.startswith('start_date_') and
                not f.startswith('end_date_')
            )
        )
        fields = _creator_fields + (
            'name',
            'birth_date_display',
            'birth_date_edtf',
            'death_date_display',
            'death_date_edtf',
            'birth_place',
            'birth_place_historic',
            'death_place',
            'background',
        )
        extra_kwargs = {
            'url': {
                'lookup_field': 'pk',
                'view_name': '%s-detail' % VIEWNAME,
            },
            # Slug field derived from `name_full` is not required
            'slug': {
                'required': False,
            },
        }
        writable_related_fields = Creator.Meta.writable_related_fields


class APIViewSet(ModelViewSet):
    """
    Artist resource.
    """
    queryset = PersonCreatorModel.objects.all()
    serializer_class = Person
    ordering_fields = (
            'name_display',
            'name_sort',
            'name_given',
            'name_family',
            'background_country',
            'background_continent',
    )


router = routers.DefaultRouter()
router.register('person', APIViewSet, VIEWNAME)
