import rest_framework_filters as filters

from glamkit_collection.models import Artwork as ArtworkModel

from ...filters import CaseInsensitiveBooleanFilter, ArtworkHasImagesFilter


class ArtworkFilter(filters.FilterSet):
    slug = filters.AllLookupsFilter(name="slug")
    title_display = filters.AllLookupsFilter(name="title_display")
    title_full = filters.AllLookupsFilter(name="title_full")
    title_short = filters.AllLookupsFilter(name="title_short")

    medium_display = filters.AllLookupsFilter(name="medium_display")
    medium_medium = filters.AllLookupsFilter(name='medium_medium')
    medium_submedium = filters.AllLookupsFilter(name='medium_submedium')
    medium_support = filters.AllLookupsFilter(name='medium_support')
    medium_support_detail = \
        filters.AllLookupsFilter(name='medium_support_detail')

    edition_is_editioned = \
        CaseInsensitiveBooleanFilter(name='edition_is_editioned')
    edition_type = filters.AllLookupsFilter(name='edition_type')
    edition_number = filters.AllLookupsFilter(name='edition_number')
    edition_size = filters.AllLookupsFilter(name='edition_size')
    edition_artist_proofs = \
        filters.AllLookupsFilter(name='edition_artist_proofs')

    date_display = filters.AllLookupsFilter(name='date_display')
    date_edtf = filters.AllLookupsFilter(name='date_edtf')
    date_edtf_earliest = filters.AllLookupsFilter(name='date_edtf_earliest')
    date_edtf_latest = filters.AllLookupsFilter(name='date_edtf_latest')
    date_sort_earliest = filters.AllLookupsFilter(name='date_sort_earliest')
    date_sort_latest = filters.AllLookupsFilter(name='date_sort_latest')

    # TODO this throws an error
    # credit_display = filters.AllLookupsFilter(name='credit_display')
    credit_image = filters.AllLookupsFilter(name='credit_image')

    dimensions_display = filters.AllLookupsFilter(name='dimensions_display')
    dimensions_is_two_dimensional = \
        CaseInsensitiveBooleanFilter(name='dimensions_is_two_dimensional')
    dimensions_extent = filters.AllLookupsFilter(name='dimensions_extent')
    dimensions_height_cm = \
        filters.AllLookupsFilter(name='dimensions_height_cm')
    dimensions_width_cm = filters.AllLookupsFilter(name='dimensions_width_cm')
    dimensions_depth_cm = filters.AllLookupsFilter(name='dimensions_depth_cm')
    dimensions_weight_kg = \
        filters.AllLookupsFilter(name='dimensions_weight_kg')

    accession_number = filters.AllLookupsFilter(name='accession_number')
    accession_date_year = filters.AllLookupsFilter(name='accession_date_year')
    accession_date_sort = filters.AllLookupsFilter(name='accession_date_sort')
    accession_method = filters.AllLookupsFilter(name='accession_method')
    accession_type = filters.AllLookupsFilter(name='accession_type')
    accession_percent_owned = \
        filters.AllLookupsFilter(name='accession_percent_owned')

    object_keywords = filters.AllLookupsFilter(name='object_keywords')

    color_css_hex_str = filters.AllLookupsFilter(name='color_css_hex_str')
    color_css_name_str = filters.AllLookupsFilter(name='color_css_name_str')
    color_crayola_hex_str = \
        filters.AllLookupsFilter(name='color_crayola_hex_str')
    color_crayola_name_str = \
        filters.AllLookupsFilter(name='color_crayola_name_str')
    color_true_hex_str = filters.AllLookupsFilter(name='color_true_hex_str')

    histogram = filters.AllLookupsFilter(name='histogram')

    location_code = filters.AllLookupsFilter(name='location_code')

    has_images = ArtworkHasImagesFilter(name='has_images')
    on_view = filters.MethodFilter(action='filter_on_view')

    class Meta:
        model = ArtworkModel

    def filter_on_view(self, request, queryset, value):
        # convert value to boolean
        val = value.lower() == 'false'
        if val:
            return queryset.not_on_view()
        else:
            return queryset.on_view()
