from django.conf.urls import url, include
from rest_framework import routers

from .images import views as images_views
from .pages import views as pages_views


# Obtain the default router and register the ImageViewSet
router = routers.DefaultRouter()
router.register(r'images', images_views.ImageViewSet, 'images')
router.register(r'pages', pages_views.PageViewSet, 'page')

# Define the URL patterns based upon the default router config.
urlpatterns = [
    url(r'^', include(router.urls)),
]
