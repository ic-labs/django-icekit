from django.conf.urls import url, include
from rest_framework import routers

from .images import views as images_views
from .pages import views as pages_views
# TODO
#from .collection import views as collection_views


# Obtain the default router and register the ImageViewSet
router = routers.DefaultRouter()
router.register(r'images', images_views.ImageViewSet, 'images-api')
router.register(r'pages', pages_views.PageViewSet, 'pages-api')
# TODO
#router.register(r'collection/artists', collection_views.ArtistViewSet)
#router.register(r'collection/artworks', collection_views.ArtworkViewSet)
#router.register(r'collection/exhibitions', collection_views.ExhibitionViewSet)
#router.register(r'collection/networks', collection_views.NetworkViewSet)
#router.register(r'collection/relationship',
#                collection_views.RelationshipsViewSet)

# Define the URL patterns based upon the default router config.
urlpatterns = [
    url(r'^', include(router.urls)),
]
