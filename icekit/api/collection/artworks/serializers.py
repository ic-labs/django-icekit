from easy_thumbnails.files import get_thumbnailer

from rest_framework import serializers
from rest_framework.settings import api_settings

from glamkit_collection.models import ArtworkArtist as ArtworkArtistModel, \
    Artwork as ArtworkModel, Artist, ArtworkImage

from ...base_serializers import ModelSubSerializer


class ArtistSummary(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Artist
        fields = (
            'url',
            'name_display',
        )
        extra_kwargs = {
            'url': {'lookup_field': 'slug'}
        }


class ArtworkArtist(serializers.HyperlinkedModelSerializer):
    """
    A list of artists related to this artwork
    ---
    """
    artist = ArtistSummary()

    class Meta:
        model = ArtworkArtistModel
        fields = (
            'artist',
            'role',
        )


class ArtworkMedium(ModelSubSerializer):
    class Meta:
        source_prefix = 'medium_'
        model = ArtworkModel
        fields = (
            'medium_display',
            'medium_medium',
            'medium_submedium',
            'medium_support',
            'medium_support_detail',
        )


class ArtworkPalette(ModelSubSerializer):
    class Meta:
        source_prefix = 'colors_'
        model = ArtworkModel
        fields = (
            'palette_colors',
        )


class ArtworkHistogram(ModelSubSerializer):
    class Meta:
        source_prefix = 'histogram_'
        model = ArtworkModel
        fields = (
            'shannon_entropy',
        )


class ArtworkTitle(ModelSubSerializer):
    class Meta:
        source_prefix = 'title_'
        model = ArtworkModel
        fields = (
            'title_display',
            'title_full',
            'title_short',
        )


class ArtworkEdition(ModelSubSerializer):
    class Meta:
        source_prefix = 'edition_'
        model = ArtworkModel
        fields = (
            'edition_is_editioned',
            'edition_type',
            'edition_id_number',
            'edition_number',
            'edition_size',
            'edition_artist_proofs',
        )


class ArtworkDate(ModelSubSerializer):
    class Meta:
        source_prefix = 'date_'
        model = ArtworkModel
        fields = (
            'date_display',
            'date_edtf',
            'date_edtf_earliest',
            'date_edtf_latest',
            'date_sort_earliest',
            'date_sort_latest',
        )


class ArtworkOrigin(ModelSubSerializer):
    class Meta:
        source_prefix = 'origin_'
        model = ArtworkModel
        fields = (
            'origin_continent',
            'origin_country',
            'origin_state_province',
            'origin_city',
            'origin_neighborhood',
            'origin_colloquial',
        )


class ArtworkCredit(ModelSubSerializer):
    class Meta:
        source_prefix = 'credit_'
        model = ArtworkModel
        fields = (
            'credit_display',
            'credit_image',
        )


class ArtworkDimensions(ModelSubSerializer):
    class Meta:
        source_prefix = 'dimensions_'
        model = ArtworkModel
        fields = (
            'dimensions_display',
            'dimensions_is_two_dimensional',
            'dimensions_extent',
            'dimensions_height_cm',
            'dimensions_width_cm',
            'dimensions_depth_cm',
            'dimensions_weight_kg',
        )


class ArtworkAccession(ModelSubSerializer):
    class Meta:
        source_prefix = 'accession_'
        model = ArtworkModel
        fields = (
            'accession_number',
            'accession_date_year',
            'accession_date_sort',
            'accession_method',
            'accession_type',
            'accession_percent_owned',
        )


class ArtworkImages(serializers.ModelSerializer):
    public_image = serializers.SerializerMethodField()
    original_image = serializers.SerializerMethodField()
    width = serializers.SerializerMethodField()
    height = serializers.SerializerMethodField()

    class Meta:
        model = ArtworkImage
        ordering = ("order", )
        fields = (
            'public_image',
            'original_image',
            'copyright',
            'credit_line',
            'caption',
            'copyright',
            'width',
            'height',
            'is_hero_image',
        )

    def get_fields(self):
        fields = super(ArtworkImages, self).get_fields()
        if 'original_image' in fields:
            request = self.context.get('request', None)
            user = getattr(request, 'user', None)
            if not (
                user and
                user.has_perm("collection.access_hires_image_files")
            ):
                del fields['original_image']
        return fields

    def get_public_image(self, obj):
        # this should return the largest image used on the public site
        # and so the definition should match the definition used in templates
        try:
            if obj.downloaded_image:
                thumbnailer = get_thumbnailer(obj.downloaded_image)
                thumbnail = thumbnailer.get_thumbnail({'size': obj.max_size()})
                return thumbnail.url
        except:
            pass
        return ""

    def get_original_image(self, obj):
        # for authorised users only!
        return obj.downloaded_image.url

    def get_width(self, obj):
        return obj.width

    def get_height(self, obj):
        return obj.height


class Artwork(serializers.HyperlinkedModelSerializer):
    title = ArtworkTitle()
    artists = ArtworkArtist(
        source="artworkartist_set",
        many=True,
        read_only=True
    )
    medium = ArtworkMedium()
    histogram = ArtworkHistogram()
    palette = ArtworkPalette()
    edition = ArtworkEdition()
    date = ArtworkDate()
    origin = ArtworkOrigin()
    credit = ArtworkCredit()
    dimensions = ArtworkDimensions()
    accession = ArtworkAccession()
    images = ArtworkImages(source="public_images", many=True, read_only=True)
    web_url = serializers.SerializerMethodField()

    def get_web_url(self, obj):
        return obj.get_website_url()

    class Meta:
        fields = (
            api_settings.URL_FIELD_NAME,
            'web_url',
            'title',
            'slug',
            'images',
            'on_view',
            'artists',
            'date',
            'department',
            'collection',
            'medium',
            'dimensions',
            'type',
            'style',
            'object_keywords',
            'technique',
            'origin',
            'num_components',
            'edition',
            'description',
            'marks',
            'credit',
            'accession',
            'location_code',
            'created_date',
            'modified_date',
            'palette',
            'histogram',
        )
        model = ArtworkModel
        extra_kwargs = {
            'url': {'lookup_field': 'slug'}
        }
