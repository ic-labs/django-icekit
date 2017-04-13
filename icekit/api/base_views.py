from django.core.exceptions import FieldError

from django.http import Http404, HttpResponseRedirect
from rest_framework import viewsets
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.reverse import reverse

from glamkit_collections.utils import alt_slugify


class ModelViewSet(viewsets.ModelViewSet):
    """
    ICEkit default API model viewset, ready for any customisation required.
    """
    lookup_field = 'pk'


class RedirectViewset(viewsets.ReadOnlyModelViewSet):
    lookup_field = 'slug'
    lookup_value_regex = ".+"
    # TODO: this will catch .format at the end, and '/'.

    def retrieve(self, request, *args, **kwargs):
        """
        If the URL slug doesn't match an object, try slugifying the URL param
        and searching alt_url for that.
        If found, redirect to the canonical URL.
        If still not found, raise 404.
        """

        try:
            instance = self.get_object()
            serializer = self.get_serializer(instance)
            return Response(serializer.data)
        except Http404:
            pass

        lookup_url_kwarg = self.lookup_url_kwarg or self.lookup_field
        slug = self.kwargs[lookup_url_kwarg]

        # fall back to accession_temp_fallback
        try:
            tmp = get_object_or_404(
                self.queryset, accession_temp_fallback=slug)
            return HttpResponseRedirect(
                reverse(self.redirect_view_name, (tmp.slug, ))
            )
        except (Http404, FieldError):
            pass

        # fall back to embark ID
        try:
            embark = get_object_or_404(self.queryset, id=int(slug))
            return HttpResponseRedirect(
                reverse(self.redirect_view_name, (embark.slug, ))
            )
        except (Http404, ValueError):
            pass

        # fall back to alt slug
        try:
            alt_slug = alt_slugify(slug)
            alt = get_object_or_404(self.queryset, alt_slug=alt_slug)
            return HttpResponseRedirect(
                reverse(self.redirect_view_name, (alt.slug, ))
            )
        except Http404:
            pass

        # well, we tried
        raise Http404
