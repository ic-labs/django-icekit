from django.conf.urls import url, include
from rest_framework import routers

from . import views


# Obtain the default router and register the ImageViewSet
router = routers.DefaultRouter()
router.register(r'images', views.ImageViewSet, 'images')

# Define the URL patterns based upon the default router config.
urlpatterns = [
    url(r'^', include(router.urls)),
]
