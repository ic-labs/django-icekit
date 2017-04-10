import rest_framework_filters as filters

from glamkit_collection.models import Artist

from ...filters import CaseInsensitiveBooleanFilter


class ArtistFilter(filters.FilterSet):
    slug = filters.AllLookupsFilter(name="slug")
    name_display = filters.AllLookupsFilter(name="name_display")
    name_full = filters.AllLookupsFilter(name="name_full")
    name_sort = filters.AllLookupsFilter(name="name_sort")
    name_given = filters.AllLookupsFilter(name="name_given")
    name_family = filters.AllLookupsFilter(name="name_family")
    name_has_eastern_order = CaseInsensitiveBooleanFilter(
        name="name_has_eastern_order")
    name_family_prefix = filters.AllLookupsFilter(name="name_family_prefix")
    name_prefix = filters.AllLookupsFilter(name="name_prefix")
    name_suffix = filters.AllLookupsFilter(name="name_suffix")
    name_aka = filters.AllLookupsFilter(name="name_aka")

    life_info_display = filters.AllLookupsFilter(name="life_info_display")
    life_info_is_living = CaseInsensitiveBooleanFilter(
        name="life_info_is_living")
    life_info_birth_date_edtf = filters.AllLookupsFilter(
        name="life_info_birth_date_edtf")
    life_info_birth_place = filters.AllLookupsFilter(
        name="life_info_birth_place")
    life_info_birth_place_historic = filters.AllLookupsFilter(
        name="life_info_birth_place_historic")
    life_info_death_date_edtf = filters.AllLookupsFilter(
        name="life_info_death_date_edtf")
    life_info_death_place = filters.AllLookupsFilter(
        name="life_info_death_place")

    background_ethnicity = filters.AllLookupsFilter(
        name="background_ethnicity")
    background_nationality = filters.AllLookupsFilter(
        name="background_nationality")
    background_neighborhood = filters.AllLookupsFilter(
        name="background_neighborhood")
    background_city = filters.AllLookupsFilter(
        name="background_city")
    background_state_province = filters.AllLookupsFilter(
        name="background_state_province")
    background_country = filters.AllLookupsFilter(
        name="background_country")
    background_continent = filters.AllLookupsFilter(
        name="background_continent")

    # active_dates only has 12 records
    active_location = filters.AllLookupsFilter(name="active_location")
    active_period = filters.AllLookupsFilter(name="active_period")
    active_school = filters.AllLookupsFilter(name="active_school")
    active_primary_media = \
        filters.AllLookupsFilter(name="active_primary_media")

    biography_summary = filters.AllLookupsFilter(name="biography_summary")
    biography_html = filters.AllLookupsFilter(name="biography_html")

    getty_ulan = filters.AllLookupsFilter(name="getty_ulan")

    class Meta:
        model = Artist
