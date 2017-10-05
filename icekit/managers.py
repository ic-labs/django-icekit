from django.contrib.contenttypes.models import ContentType
from django.db import models


class LayoutQuerySet(models.query.QuerySet):

    def for_model(self, model, **kwargs):
        """
        Return layouts that are allowed for the given model.
        """
        queryset = self.filter(
            content_types=ContentType.objects.get_for_model(model),
            **kwargs
        )
        return queryset


# Adapted from https://stackoverflow.com/a/26219292/4970
class GoogleMapManager(models.Manager):

    def annotate_distance_in_km(self, latitude, longitude):
        """
        Return all records with non-null latitude/longitude values with the
        annotation value `distance_in_km` which is the distance between
        the record and the given `latitude`/`longitude` location.
        """
        # Great circle distance formula, taken on faith from StackOverflow link
        # above, see also https://en.wikipedia.org/wiki/Great-circle_distance
        # NOTE: We use psql-specific COALESCE() to choose marker lat/long
        # values when available (non-NULL) otherwise center lat/long values
        GCD = """
            6371
            * ACOS(
                COS(RADIANS(%s))
                * COS(RADIANS(
                    COALESCE(map_marker_lat, map_center_lat)
                  ))
                * COS(RADIANS(
                    COALESCE(map_marker_long, map_center_long)
                  )
                - RADIANS(%s))
                + SIN(RADIANS(%s))
                * SIN(RADIANS(
                    COALESCE(map_marker_lat, map_center_lat)
                ))
            )
            """
        return self.get_queryset() \
            .exclude(map_center_lat=None) \
            .exclude(map_center_long=None) \
            .annotate(
                distance_in_km=models.expressions.RawSQL(
                    GCD,
                    (latitude, longitude, latitude)
                )
            ) \
            .order_by('distance_in_km')

    def nearby(self, latitude, longitude, proximity_in_km):
        return self \
            .annotate_distance_in_km(latitude, longitude) \
            .filter(distance_in_km__lt=proximity_in_km)
