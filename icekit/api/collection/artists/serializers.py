from rest_framework import serializers
from rest_framework.settings import api_settings

from glamkit_collection.models import ArtworkArtist as ArtworkArtistModel, \
    Artist as ArtistModel, Artwork as ArtworkModel

from ...base_serializers import ModelSubSerializer


class ArtworkSummary(serializers.HyperlinkedModelSerializer):
    """
    Minimal artwork data
    """
    class Meta:
        model = ArtworkModel
        fields = (
            'url',
            'title_display',
            'date_display',
        )
        extra_kwargs = {
            'url': {'lookup_field': 'slug'}
        }


class ArtistArtwork(serializers.HyperlinkedModelSerializer):
    artwork = ArtworkSummary(
        help_text="A summary of the artwork sufficient to show a thumbnail")
    role = serializers.CharField(
        help_text="The role of this creator with respect to the work")
    # other_creators = serializers.ArtistSummary():

    class Meta:
        model = ArtworkArtistModel
        fields = (
            'artwork',
            'role',
        )


class ArtistName(ModelSubSerializer):
    class Meta:
        source_prefix = 'name_'
        model = ArtistModel
        fields = (
            'name_display',
            'name_full',
            'name_sort',
            'name_given',
            'name_family',
            'name_has_eastern_order',
            'name_family_prefix',
            # 'name_elaboration', # this seems to have personal address info.
            'name_prefix',
            'name_suffix',
            'name_aka',
        )


class LifeInfo(ModelSubSerializer):
    # TODO: wrap EDTF dates into an object
    class Meta:
        source_prefix = 'life_info_'
        model = ArtistModel
        fields = (
            'life_info_display',
            'life_info_is_living',
            'life_info_birth_date_display',
            'life_info_birth_date_edtf',
            'life_info_birth_date_edtf_earliest',
            'life_info_birth_date_edtf_latest',
            'life_info_birth_date_sort_earliest',
            'life_info_birth_date_sort_latest',
            'life_info_birth_place',
            'life_info_birth_place_historic',
            'life_info_death_date_display',
            'life_info_death_date_edtf',
            'life_info_death_date_edtf_earliest',
            'life_info_death_date_edtf_latest',
            'life_info_death_date_sort_earliest',
            'life_info_death_date_sort_latest',
            'life_info_death_place',
        )


class Background(ModelSubSerializer):
    class Meta:
        source_prefix = 'background_'
        model = ArtistModel
        fields = (
            'background_ethnicity',
            'background_nationality',
            'background_neighborhood',
            'background_city',
            'background_state_province',
            'background_country',
            'background_continent',
        )


class Career(ModelSubSerializer):
    class Meta:
        source_prefix = 'active_'
        model = ArtistModel
        fields = (
            'active_location',
            'active_period',
            'active_school',
            'active_primary_media',
        )


class Biography(ModelSubSerializer):
    class Meta:
        source_prefix = 'biography_'
        model = ArtistModel
        fields = (
            'biography_summary',
            'biography_html',
        )


class GettyData(ModelSubSerializer):
    class Meta:
        source_prefix = 'getty_'
        model = ArtistModel
        fields = (
            'relationships',
            'getty_ulan',
        )


class Artist(serializers.HyperlinkedModelSerializer):
    name = ArtistName(help_text="Parts and forms of the Artist's name")
    artworks = ArtistArtwork(
        help_text="the artworks by this artist, in chronological order",
        source="artworkartist_set",
        many=True,
        read_only=True
    )
    life_info = LifeInfo(help_text="Birth and death dates and places")
    background = Background(help_text="Ethnicity, nationality and culture")
    career = Career(
        help_text="Active dates, location, period. School and primary media"
    )
    biography = Biography(help_text="Biographical texts")

    web_url = serializers.SerializerMethodField()

    getty_data = GettyData(help_text='Data gathered from Getty Institute')

    def get_web_url(self, obj):
        return obj.get_website_url

    class Meta:
        model = ArtistModel
        fields = (
            api_settings.URL_FIELD_NAME,
            'web_url',
            'name',
            'slug',
            'gender',
            'website',
            'artworks',
            'life_info',
            'background',
            'career',
            'biography',
            'getty_data',
        )
        extra_kwargs = {
            'url': {'lookup_field': 'slug'}
        }
